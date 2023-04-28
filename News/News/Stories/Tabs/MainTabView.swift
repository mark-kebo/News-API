//
//  MainTabView.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import SwiftUI
import RealmSwift

struct MainTabView: View {
    private let viewModel: MainTabViewModel = MainTabViewModel()
    
    var body: some View {
        TabView {
            NewsView(viewModel: NewsViewModel(source: nil))
                .tabItem {
                    Label("NewsTabTitle".localized,
                          systemImage: "newspaper")
                }
            FavoriteNewsView(viewModel: FavoriteNewsViewModel())
                .tabItem {
                    Label("FavoriteNewsTabTitle".localized,
                          systemImage: "star")
                }
            SourcesView(viewModel: SourcesViewModel())
                .tabItem {
                    Label("SourcesTabTitle".localized,
                          systemImage: "doc.text.magnifyingglass")
                }
        }
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
