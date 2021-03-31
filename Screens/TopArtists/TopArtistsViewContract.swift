//
//  TopArtistsContract.swift
//  LastFM
//
//  Created by Timur Mustafaev on 28.03.2021.
//

import SwiftUI

protocol TopArtistsViewModelType: ObservableObject {
    var state: ViewState<[RowViewModel]> { get }
    
    func didLoad()
}

protocol TopArtistViewRouterType {
    func artistDetailsView(for artistName: String) -> AnyView
}
