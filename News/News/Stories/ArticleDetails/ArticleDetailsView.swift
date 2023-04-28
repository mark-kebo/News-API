//
//  ArticleDetailsView.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import SwiftUI

struct ArticleDetailsView: View {
    private let spacing: CGFloat = 4
    private let imageSize: CGFloat = 300
    private let favoriteButtonSize: CGFloat = 32

    let article: ArticleViewDataItem
    let action: (() -> Void)?

    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                HStack {
                    if let action {
                        Spacer()
                        Button(action: action) {
                            Image(systemName: article.isFavorite ? "star.fill" : "star")
                                .resizable()
                                .frame(width: favoriteButtonSize, height: favoriteButtonSize)
                                .foregroundColor(.yellow)
                        }
                        .padding()
                    }
                }
                if let url = article.imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: imageSize, maxHeight: imageSize)
                }
                VStack(alignment: .leading, spacing: spacing) {
                    Text(article.title ?? "")
                        .font(.system(size: 18, weight: .semibold))
                    Text(article.content ?? "")
                        .font(.system(size: 16, weight: .regular))
                    Spacer()
                    Text(article.author ?? "")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                    Text(article.source ?? "")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                    if let publishedAt = article.publishedAt {
                        HStack(spacing: spacing) {
                            Text(publishedAt, style: .date)
                                .foregroundColor(.gray)
                                .font(.system(size: 12, weight: .bold))
                            Text(publishedAt, style: .time)
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct ArticleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailsView(article: ArticleViewDataItem.placeholder, action: nil)
    }
}
