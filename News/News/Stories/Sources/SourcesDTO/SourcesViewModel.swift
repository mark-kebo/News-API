//
//  SourcesViewModel.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation
import Combine

protocol SourcesViewModelProtocol: ObservableObject {
    var viewDataItems: [SourceViewDataItem] { get set }
    var viewModelState: ViewModelState { get set }
    var viewDataItemsPlaceholder: [SourceViewDataItem] { get }
    
    func refreshSources()
}

final class SourcesViewModel: SourcesViewModelProtocol {
    let viewDataItemsPlaceholder: [SourceViewDataItem] = [SourceViewDataItem.placeholder, SourceViewDataItem.placeholder,
                                                          SourceViewDataItem.placeholder, SourceViewDataItem.placeholder,
                                                          SourceViewDataItem.placeholder, SourceViewDataItem.placeholder,
                                                          SourceViewDataItem.placeholder, SourceViewDataItem.placeholder]
    @Published var viewDataItems: [SourceViewDataItem] = []
    @Published var viewModelState: ViewModelState = .loading
    
    private let requestService: APIRequestServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(requestService: APIRequestServiceProtocol = APIRequestService()) {
        self.requestService = requestService
        viewModelState = .loading
        refreshSources()
    }
    
    func refreshSources() {
        requestService.sendAPIRequest(webService: .getSources, [Source].self)
        .sink { [weak self] completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                self?.viewModelState = .error(error: error)
            }
        } receiveValue: { [weak self] result in
            self?.viewModelState = .success
            self?.updateViewDataItems(with: result.data)
        }
        .store(in: &self.cancellables)
    }
    
    private func updateViewDataItems(with news: [Source]) {
        let pageViewData = news.map { SourceViewDataItem(source: $0) }
        self.viewDataItems.append(contentsOf: pageViewData)
    }
}
