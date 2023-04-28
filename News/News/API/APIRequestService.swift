//
//  APIRequestService.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation
import Combine

protocol APIRequestServiceProtocol: AnyObject {
    func sendAPIRequest<T: Decodable>(webService: WebService, _: T.Type) -> AnyPublisher<APIResponseResult<T>, ActionError>
}

final class APIRequestService: APIRequestServiceProtocol {
    
    private let requestFactory: RequestAbsoluteURLFactoryProtocol
    private let responseHandler: APIResponseHandlerProtocol

    init(
        requestFactory: RequestAbsoluteURLFactoryProtocol = RequestAbsoluteURLFactory(),
        responseHandler: APIResponseHandlerProtocol = APIResponseHandler())
    {
        self.requestFactory = requestFactory
        self.responseHandler = responseHandler
    }

    func sendAPIRequest<T: Decodable>(webService: WebService, _: T.Type) -> AnyPublisher<APIResponseResult<T>, ActionError> {
        guard let requestAbsoluteURL = requestFactory.requestAbsoluteURL(webService: webService) else {
            let errorMessage = "Can't create API request"
            NSLog(errorMessage)
            return Fail(error: .network(errorMessage))
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
        NSLog("Send request: \(requestAbsoluteURL)")
        return URLSession.shared.dataTaskPublisher(for: requestAbsoluteURL)
            .tryMap { [weak self] data, response in
                guard let self else { throw ActionError.objectParsing() }
                let parsedResults = self.responseHandler.parsedResponse(data: data) as Result<APIResponseResult<T>, ActionError>
                NSLog("API Response parsed successfully for \(T.self)")
                switch parsedResults {
                case .success(let apiResponse):
                    return apiResponse
                case .failure(let error):
                    NSLog("Load data error: \(error.errorMessage)")
                    throw error
                }
            }
            .timeout(.seconds(AppConstants.sessionTimeoutIntervalSec),
                     scheduler: DispatchQueue.main, options: nil,
                     customError: { return ActionError.timeout() })
            .mapError { error in
                NSLog("Load data error code: \(String(describing: (error as? URLError)?.code))")
                switch (error as? URLError)?.code {
                case .some(.notConnectedToInternet),
                        .some(.dataNotAllowed),
                        .some(.resourceUnavailable):
                    let reachabilityError = ActionError.reachability()
                    NSLog(reachabilityError.errorMessage)
                    return reachabilityError
                case .some(.timedOut):
                    let timeoutError = ActionError.timeout()
                    NSLog("Request time out: \(timeoutError.errorMessage)")
                    return timeoutError
                default:
                    let errorMessage = "Can't download API data for resultObject: \(error.localizedDescription)"
                    NSLog(errorMessage)
                    return error as? ActionError ?? ActionError.network(errorMessage)
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
