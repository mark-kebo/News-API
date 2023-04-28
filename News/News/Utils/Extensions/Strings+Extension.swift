//
//  Strings+Extension.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

extension String {
    
    // MARK: - Language Localization
    
    public var localized: String {
        let message = NSLocalizedString(self, comment: "")
        if message != self {
            return message
        }
        guard let path = Bundle.main.path(forResource: "en", ofType: "lproj") else { return self }
        guard let bundle = Bundle(path: path) else { return self }
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
    
    // MARK: - To Date
    
    func toDate(format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
