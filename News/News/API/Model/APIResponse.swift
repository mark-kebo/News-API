//
//  APIResponse.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let status: APIResponseStatus
    let totalResults: Int?
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
        case sources
        case errorMessage = "message"
        case errorCode = "code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalResults = try? values.decode(Int?.self, forKey: .totalResults)
        let statusString = try values.decode(String.self, forKey: .status)
        let errorMessage = try? values.decode(String?.self, forKey: .errorMessage)
        let errorCode = try? values.decode(String?.self, forKey: .errorCode)
        
        status = APIResponseStatus(rawValue: statusString,
                                   errorMessage: errorMessage,
                                   errorCode: errorCode)
        
        if values.contains(.articles) {
            do {
                data = try values.decode(T?.self, forKey: .articles)
            } catch (let error) {
                NSLog("Can't get 'articles' from API response: \(error)")
                data = nil
            }
        } else if values.contains(.sources) {
            do {
                data = try values.decode(T?.self, forKey: .sources)
            } catch (let error) {
                NSLog("Can't get 'sources' from API response: \(error)")
                data = nil
            }
        } else {
            NSLog("Data does not exist in API response")
            data = nil
        }
    }
}

struct APIResponseResult<T: Decodable> {
    let totalResults: Int
    let data: T
}

enum APIResponseStatus {
    case success
    case error(_ code: String,
               _ message: String)
    
    init(rawValue: String,
         errorMessage: String? = nil,
         errorCode: String? = nil) {
        switch rawValue {
        case "ok":
            self = .success
        case "error":
            self = .error(errorCode ?? "",
                          errorMessage ?? "GlobalUnexpectableErrorTitle".localized)
        default:
            self = .error("", "GlobalUnexpectableErrorTitle".localized)
        }
    }
}
