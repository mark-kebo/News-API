//
//  ActionError.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

public enum ActionError: Error, Equatable {
    case reachability(_ title: String = "ErrorNetworkTitle".localized,
                      _ message: String = "ErrorNetworkMessage".localized)
    case network(_ message: String)
    case custom(_ title: String, _ message: String)
    case timeout(_ message: String = "ErrorTimeout".localized)
    case objectParsing(_ message: String = "ErrorObjectParcing".localized)
    
    var errorMessage: String {
        switch self {
        case .reachability(_, let message),
                .network(let message),
                .timeout(let message),
                .objectParsing(let message),
                .custom(_, let message):
            return message
        }
    }
    
    var errorTitle: String {
        switch self {
        case .reachability(let title, _),
                .custom(let title, _):
            return title
        default:
            return "ErrorTitle".localized
        }
    }
}
