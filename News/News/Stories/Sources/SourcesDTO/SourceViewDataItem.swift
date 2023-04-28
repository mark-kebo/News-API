//
//  SourceViewDataItem.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

struct SourceViewDataItem: Hashable {
    let id: String?
    let name: String?
    let description: String?
    
    init(source: Source) {
        self.id = source.id
        self.name = source.name
        self.description = source.description
    }
}

extension SourceViewDataItem {
    static var placeholder: SourceViewDataItem {
        SourceViewDataItem(source: Source(id: UUID().uuidString, name: UUID().uuidString,
                                          description: UUID().uuidString, url: nil,
                                          category: nil, language: nil, country: nil))
    }
}
