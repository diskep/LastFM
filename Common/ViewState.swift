//
//  ViewState.swift
//  LastFM
//
//  Created by Timur Mustafaev on 28.03.2021.
//

import Foundation

enum ViewState<T> {
    case loading
    case data(T)
    case error
}
