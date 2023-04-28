//
//  APIRequestAttributes.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

enum RequestMethod: String {
    case GET
    case POST
    case DELETE
}

struct APIRequestAttributes {
    let endpoint: APIEndpoint
    let method: RequestMethod
    let params: [String: Any]
}
