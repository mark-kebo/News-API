//
//  ArticleView.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import SwiftUI

struct ArticleView: View {
    private let spacing: CGFloat = 4
    private let imageSize: CGFloat = 100
    private let favoriteButtonSize: CGFloat = 24

    @State var isShowLoading: Bool
    let article: ArticleViewDataItem
    let action: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack {
                VStack(alignment: .leading, spacing: spacing) {
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
            HStack(alignment: .top, spacing: spacing * 2) {
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
                Text(article.title ?? "")
                    .font(.system(size: 18, weight: .semibold))
            }
        }
        .redacted(reason: isShowLoading ? .placeholder : [])
        .allowsHitTesting(!isShowLoading)
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(isShowLoading: false, article: ArticleViewDataItem.placeholder, action: nil)
    }
}
