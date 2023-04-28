//
//  SourceView.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation
import SwiftUI

struct SourceView: View {
    private let spacing: CGFloat = 4

    @State var isShowLoading: Bool
    
    let source: SourceViewDataItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(source.name ?? "")
                .font(.system(size: 16, weight: .semibold))
            Text(source.description ?? "")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.gray)
        }
        .redacted(reason: isShowLoading ? .placeholder : [])
        .allowsHitTesting(!isShowLoading)
    }
}

struct SourceView_Previews: PreviewProvider {
    static var previews: some View {
        SourceView(isShowLoading: false, source: SourceViewDataItem.placeholder)
    }
}
