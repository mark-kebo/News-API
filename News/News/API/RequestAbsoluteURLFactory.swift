//
//  RequestAbsoluteURLFactory.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

protocol RequestAbsoluteURLFactoryProtocol: AnyObject {
    func requestAbsoluteURL(webService: WebService) -> URL?
}

final class RequestAbsoluteURLFactory: RequestAbsoluteURLFactoryProtocol {
    func requestAbsoluteURL(webService: WebService) -> URL? {
        let baseUrlString = AppConstants.apiPath + webService.attributes.endpoint.rawValue
        let baseUrl = URL(string: baseUrlString)
        guard let urlComponents = requestComponents(from: webService.attributes.params,
                                                    with: baseUrlString) else { return baseUrl }
        guard let pathWithComponents = urlComponents.url?.absoluteURL else { return baseUrl }
        return pathWithComponents
    }
    
    private func requestComponents(from params: [String : Any], with requestPath: String) -> URLComponents? {
        var components = URLComponents(string: requestPath)
        components?.queryItems = params.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: String(describing: value))
        }
        components?.queryItems?.append(URLQueryItem(name: "apiKey", value: AppConstants.apiKey))
        return components
    }
}
