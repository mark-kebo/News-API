//
//  FavoriteNewsView.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import SwiftUI

struct FavoriteNewsView<ViewModel>: View where ViewModel: FavoriteNewsViewModelProtocol {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.viewDataItems.isEmpty {
                Text("NewsScreenEmptyMessage".localized)
            } else {
                List {
                    ForEach(viewModel.viewDataItems, id: \.self) { article in
                        NavigationLink(destination: ArticleDetailsView(article: article, action: nil)) {
                            ArticleView(isShowLoading: false,
                                        article: article, action: nil)
                        }
                    }
                    .onDelete(perform: viewModel.deleteArticleFromFavorites)
                }
                .navigationTitle("FavoriteNewsTabTitle".localized)
            }
        }
        .onAppear() {
            viewModel.refreshNews()
        }
    }
}

struct FavoriteNewsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteNewsView(viewModel: FavoriteNewsViewModel())
    }
}
