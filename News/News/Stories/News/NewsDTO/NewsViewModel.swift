//
//  NewsViewModel.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation
import Combine

protocol NewsViewModelProtocol: ObservableObject {
    var viewDataItems: [ArticleViewDataItem] { get set }
    var viewModelState: ViewModelState { get set }
    var viewDataItemsPlaceholder: [ArticleViewDataItem] { get }
    var screenTitle: String { get }
    var isLoadNextPageAvailable: Bool { get }
    
    func refreshNews()
    func loadNextNewsPage()
    func updateFavoritesStatus()
    func favoriteStatusChanged(index: Int)
}

final class NewsViewModel: NewsViewModelProtocol {
    
    var screenTitle: String { source?.name ?? "NewsScreenTitle".localized }
    let viewDataItemsPlaceholder: [ArticleViewDataItem] = [ArticleViewDataItem.placeholder, ArticleViewDataItem.placeholder,
                                                           ArticleViewDataItem.placeholder, ArticleViewDataItem.placeholder,
                                                           ArticleViewDataItem.placeholder, ArticleViewDataItem.placeholder,
                                                           ArticleViewDataItem.placeholder, ArticleViewDataItem.placeholder]
    var isLoadNextPageAvailable: Bool {
        viewDataItems.count < totalViewDataCount
    }
    @Published var viewDataItems: [ArticleViewDataItem] = []
    @Published var viewModelState: ViewModelState = .loading
    
    private let source: SourceViewDataItem?
    private let requestService: APIRequestServiceProtocol
    private let realmManager: RealmManagerProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var currentPage: Int = 1
    private let pageSize: Int = 20
    private var totalViewDataCount: Int = 0
    
    private var favoriteArticles: [ArticleEntity] {
        guard let entities = realmManager.readAllOfType(ArticleEntity.self) else { return [] }
        return Array(entities)
    }
    
    init(source: SourceViewDataItem?,
         realmManager: RealmManagerProtocol = RealmManager(),
         requestService: APIRequestServiceProtocol = APIRequestService()) {
        self.requestService = requestService
        self.realmManager = realmManager
        self.source = source
        viewModelState = .loading
    }
    
    func refreshNews() {
        currentPage = 1
        getNews(isNeedRefresh: true)
    }
    
    func loadNextNewsPage() {
        currentPage += 1
        getNews()
    }
    
    func favoriteStatusChanged(index: Int) {
        let currentFevoriteStatus = viewDataItems[index].isFavorite
        if currentFevoriteStatus,
            let entity = favoriteArticles.first(where: { $0.title == viewDataItems[index].title }) {
            realmManager.delete(entity)
        } else {
            let entity = ArticleEntity(viewDataItem: viewDataItems[index])
            realmManager.create(entity)
        }
        viewDataItems[index].isFavorite = !currentFevoriteStatus
    }
    
    func updateFavoritesStatus() {
        for index in 0..<viewDataItems.count {
            viewDataItems[index].isFavorite = favoriteArticles.contains(where: { viewDataItems[index].title == $0.title })
        }
    }
    
    private func getNews(isNeedRefresh: Bool = false) {
        NSLog("Get news per page: \(currentPage)")
        requestService.sendAPIRequest(webService: .getNews(sources: source?.id,
                                                           page: currentPage,
                                                           pageSize: pageSize), [Article].self)
        .sink { [weak self] completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                self?.viewModelState = .error(error: error)
            }
        } receiveValue: { [weak self] result in
            self?.viewModelState = .success
            if isNeedRefresh {
                self?.viewDataItems = []
            }
            self?.totalViewDataCount = result.totalResults
            self?.updateViewDataItems(with: result.data)
        }
        .store(in: &self.cancellables)
    }
    
    private func updateViewDataItems(with news: [Article]) {
        let pageViewData = news.map { article in
            ArticleViewDataItem(article: article,
                                isFavorite: favoriteArticles.contains(where: { article.title == $0.title }))
        }
        self.viewDataItems.append(contentsOf: pageViewData)
    }
}
