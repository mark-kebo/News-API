//
//  APIResponseHandler.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

protocol APIResponseHandlerProtocol: AnyObject {
    func parsedResponse<T: Decodable>(data: Data) -> Result<APIResponseResult<T>, ActionError>
}

final class APIResponseHandler: APIResponseHandlerProtocol {
    
    func parsedResponse<T: Decodable>(data: Data) -> Result<APIResponseResult<T>, ActionError> {
        let parsedResponseData = data.decoded() as Result<APIResponse<T>, ActionError>
        switch parsedResponseData {
        case .success(let apiResponse):
            return parsedResponseResult(apiResponse)
        case .failure(let parserError):
            NSLog("Can't parse APIResponse \(T.self): \(parserError.errorMessage)")
            return .failure(parserError)
        }
    }
    
    private func parsedResponseResult<T: Decodable>(_ apiResponse: APIResponse<T>) -> Result<APIResponseResult<T>, ActionError> {
        let responseStatus = apiResponse.status
        NSLog("API Response parsed successfully, status: \(responseStatus)")
        switch responseStatus {
        case .success:
            guard let payload = apiResponse.data else {
                let errorMessage = "Can't parse API response 'data' \(T.self) type"
                NSLog(errorMessage)
                return .failure(.objectParsing())
            }
            NSLog("Payload \(T.self) parsed successfully")
            return .success(APIResponseResult(totalResults: apiResponse.totalResults ?? 0, data: payload))
        case .error(let code, let message):
            let errorDecodedMessage = "Parsing error for \(T.self)"
            NSLog("\(errorDecodedMessage), key: \(code), message: \(message)")
            let responseError = ActionError.network(message)
            return .failure(responseError)
        }
    }
}
