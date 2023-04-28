//
//  Data+Extension.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

extension Data {
    func decoded<T: Decodable>() -> Result<T, ActionError> {
        do {
            let parsedObject = try JSONDecoder().decode(T.self, from: self)
            return .success(parsedObject)
        } catch (let error) {
            let errorMessage = "Can't parse Data for \(T.self) type: \(error)"
            NSLog(errorMessage)
            return .failure(.objectParsing())
        }
    }
}
