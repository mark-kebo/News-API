//
//  ViewModelState.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation

enum ViewModelState: Equatable {
    case loading
    case success
    case error(error: ActionError)
}
