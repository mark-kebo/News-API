//
//  ArticleEntity.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation
import RealmSwift

final class ArticleEntity: Object {
    @objc dynamic var source: String?
    @objc dynamic var author: String?
    @objc dynamic var title: String?
    @objc dynamic var descr: String?
    @objc dynamic var imageURL: String?
    @objc dynamic var publishedAt: Date?
    @objc dynamic var content: String?
    
    convenience init(viewDataItem: ArticleViewDataItem) {
        self.init()
        self.source = viewDataItem.source
        self.author = viewDataItem.author
        self.title = viewDataItem.title
        self.descr = viewDataItem.description
        self.imageURL = viewDataItem.imageURL?.absoluteString
        self.publishedAt = viewDataItem.publishedAt
        self.content = viewDataItem.content
    }
}
