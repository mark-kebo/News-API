//
//  SourcesView.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import SwiftUI

struct SourcesView<ViewModel>: View where ViewModel: SourcesViewModelProtocol {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            switch viewModel.viewModelState {
            case .error(let error):
                ErrorView(error: error) {
                    viewModel.refreshSources()
                }
                .navigationTitle("SourcesTabTitle".localized)
            case .loading:
                List(viewModel.viewDataItemsPlaceholder, id: \.self) { source in
                    NavigationLink(destination: NewsView(viewModel: NewsViewModel(source: source))) {
                        SourceView(isShowLoading: true,
                                   source: source)
                    }
                }
                .navigationTitle("SourcesTabTitle".localized)
            default:
                if viewModel.viewDataItems.isEmpty {
                    Text("NewsScreenEmptyMessage".localized)
                } else {
                    List(0..<viewModel.viewDataItems.count, id: \.self) { index in
                        NavigationLink(destination: NewsView(viewModel: NewsViewModel(source: viewModel.viewDataItems[index]))) {
                            SourceView(isShowLoading: false,
                                       source: viewModel.viewDataItems[index])
                        }
                    }
                    .refreshable {
                        viewModel.refreshSources()
                    }
                    .navigationTitle("SourcesTabTitle".localized)
                }
            }
        }
    }
}

struct SourcesView_Previews: PreviewProvider {
    static var previews: some View {
        SourcesView(viewModel: SourcesViewModel())
    }
}
