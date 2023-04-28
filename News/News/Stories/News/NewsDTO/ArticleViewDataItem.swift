//
//  ArticleViewDataItem.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

struct ArticleViewDataItem: Hashable {
    let source: String?
    let author: String?
    let title: String?
    let description: String?
    let imageURL: URL?
    let publishedAt: Date?
    let content: String?
    var isFavorite: Bool
    
    init(article: Article, isFavorite: Bool) {
        self.source = article.source?.name
        self.author = article.author
        self.title = article.title
        self.description = article.description
        self.publishedAt = article.publishedAt?.toDate()
        self.content = article.content
        self.isFavorite = isFavorite
        self.imageURL = URL(string: article.urlToImage ?? "")
    }
    
    init(entity: ArticleEntity) {
        self.isFavorite = true
        self.source = entity.source
        self.author = entity.author
        self.title = entity.title
        self.description = entity.description
        self.publishedAt = entity.publishedAt
        self.content = entity.content
        self.imageURL = URL(string: entity.imageURL ?? "")
    }
}

extension ArticleViewDataItem {
    static var placeholder: ArticleViewDataItem {
        ArticleViewDataItem(article: Article(source: Source(id: UUID().uuidString, name: UUID().uuidString,
                                                            description: nil, url: nil, category: nil,
                                                            language: nil, country: nil),
                                             author: UUID().uuidString, title: UUID().uuidString,
                                             description: nil, url: nil, urlToImage: nil,
                                             publishedAt: "2023-04-27T11:43:12Z",
                                             content: UUID().uuidString),
                            isFavorite: false)
    }
}
