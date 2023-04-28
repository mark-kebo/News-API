//
//  ErrorView.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import SwiftUI

struct ErrorView: View {
    let error: ActionError
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(error.errorTitle)
                .font(.system(size: 18, weight: .bold))
            Text(error.errorMessage)
                .font(.system(size: 16, weight: .semibold))
            Button("NewsScreenReloadButtonTitle".localized, action: action)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: .timeout()) {}
    }
}
