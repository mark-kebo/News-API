//
//  NewsView.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import SwiftUI

struct NewsView<ViewModel>: View where ViewModel: NewsViewModelProtocol {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            switch viewModel.viewModelState {
            case .error(let error):
                ErrorView(error: error) {
                    viewModel.refreshNews()
                }
                .navigationTitle(viewModel.screenTitle)
            case .loading:
                List(viewModel.viewDataItemsPlaceholder, id: \.self) { article in
                    NavigationLink(destination: ArticleDetailsView(article: article, action: nil)) {
                        ArticleView(isShowLoading: true,
                                    article: article, action: nil)
                    }
                }
                .navigationTitle(viewModel.screenTitle)
            default:
                if viewModel.viewDataItems.isEmpty {
                    Text("NewsScreenEmptyMessage".localized)
                } else {
                    List(0..<viewModel.viewDataItems.count, id: \.self) { index in
                        NavigationLink(destination: ArticleDetailsView(article: viewModel.viewDataItems[index]) {
                            viewModel.favoriteStatusChanged(index: index)
                        }) {
                            ArticleView(isShowLoading: false,
                                        article: viewModel.viewDataItems[index]) {
                                viewModel.favoriteStatusChanged(index: index)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        if viewModel.viewDataItems.count - 1 == index && viewModel.isLoadNextPageAvailable {
                            Text("NewsScreenPagingLoading".localized)
                                .onAppear() {
                                    viewModel.loadNextNewsPage()
                                }
                        }
                    }
                    .refreshable {
                        viewModel.refreshNews()
                    }
                    .navigationTitle(viewModel.screenTitle)
                }
            }
        }
        .onAppear() {
            viewModel.refreshNews()
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(viewModel: NewsViewModel(source: nil))
    }
}
