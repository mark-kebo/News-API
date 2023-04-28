//
//  FavoriteNewsViewModel.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation
import Combine

protocol FavoriteNewsViewModelProtocol: ObservableObject {
    var viewDataItems: [ArticleViewDataItem] { get set }
    
    func refreshNews()
    func deleteArticleFromFavorites(at offsets: IndexSet)
}

final class FavoriteNewsViewModel: FavoriteNewsViewModelProtocol {

    @Published var viewDataItems: [ArticleViewDataItem] = []
    
    private let realmManager: RealmManagerProtocol
    
    private var favoriteArticles: [ArticleEntity] {
        guard let entities = realmManager.readAllOfType(ArticleEntity.self) else { return [] }
        return Array(entities)
    }
    
    init(realmManager: RealmManagerProtocol = RealmManager()) {
        self.realmManager = realmManager
    }
    
    func refreshNews() {
        viewDataItems = favoriteArticles.map { ArticleViewDataItem(entity: $0) }
    }
 
    func deleteArticleFromFavorites(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let currentFevoriteStatus = viewDataItems[index].isFavorite
        if currentFevoriteStatus,
            let entity = favoriteArticles.first(where: { $0.title == viewDataItems[index].title }) {
            realmManager.delete(entity)
            viewDataItems.remove(at: index)
        }
    }
}
