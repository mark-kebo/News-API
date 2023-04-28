//
//  APIEndpoint.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

enum APIEndpoint: String {
    case sources = "top-headlines/sources"
    case topHeadlines = "top-headlines"
}

enum WebService {
    case getNews(sources: String?, page: Int, pageSize: Int)
    case getSources
}

extension WebService {
    var attributes: APIRequestAttributes {
        switch self {
        case .getSources:
            return APIRequestAttributes(endpoint: .sources,
                                        method: .GET,
                                        params: [:])
            
        case .getNews(let sources, let page, let pageSize):
            var params: [String : Any] = [
                "page": page,
                "pageSize": pageSize
            ]
            if let sources {
                params["sources"] = sources
            } else {
                params["category"] = "technology"
            }
            return APIRequestAttributes(endpoint: .topHeadlines,
                                        method: .GET,
                                        params: params)
        }
    }
}
