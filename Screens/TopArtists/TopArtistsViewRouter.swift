//
//  TopArtistsViewRouter.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import SwiftUI
import Swinject

final class TopArtistsViewRouter: TopArtistViewRouterType {
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func artistDetailsView(for artistName: String) -> AnyView {
        let artistDetails = resolver.resolve(ArtistDetailsView<ArtistDetailsViewModel>.self, argument: artistName)!
        return AnyView(artistDetails)
    }
}


// MARK: - Mock
final class TopArtistViewRouterMock: TopArtistViewRouterType {
    func artistDetailsView(for artistId: String) -> AnyView {
        AnyView(EmptyView())
    }
}
