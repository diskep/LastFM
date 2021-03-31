//
//  TopArtistFlowAssembly.swift
//  LastFM
//
//  Created by Timur Mustafaev on 29.03.2021.
//

import Swinject

final class TopArtistFlowAssembly: Assembly {
    
    func assemble(container: Container) {
        registerTopArtists(in: container)
        registerArtistDetails(in: container)
    }
    
    private func registerTopArtists(in container: Container) {
        container.register(TopArtistsViewModel.self) { resolver in
            let repository = resolver.resolve(TopArtistsRepository.self)! // there is nothing bad in this force unwrap as we register all dependencies in Container and we'll have it in Resolver.
            return TopArtistsViewModel(repository: repository)
        }
        
        container.register(TopArtistsView<TopArtistsViewModel>.self) { resolver in
            let viewModel = resolver.resolve(TopArtistsViewModel.self)!
            let router = resolver.resolve(TopArtistsViewRouter.self)!
            return TopArtistsView(viewModel: viewModel, router: router)
        }
        
        container.register(TopArtistsViewRouter.self) { resolver in
            TopArtistsViewRouter(resolver: resolver)
        }
        
        container.register(TopArtistsRepository.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceType.self)!
            let storageService = resolver.resolve(StorageService.self)!
            let reachability = resolver.resolve(ReachabilityService.self)!
            return TopArtistsRepository(networkService: networkService, storageService: storageService, reachability: reachability)
        }
    }
    
    private func registerArtistDetails(in container: Container) {
        container.register(ArtistDetailsView<ArtistDetailsViewModel>.self) { (resolver, artistId: String) in
            let viewModel = resolver.resolve(ArtistDetailsViewModel.self, argument: artistId)!
            return ArtistDetailsView(viewModel: viewModel)
        }
        
        container.register(ArtistDetailsViewModel.self) { (resolver, artist: String) in
            let repository = resolver.resolve(ArtistDetailsRepository.self)!
            return ArtistDetailsViewModel(artist: artist, repository: repository)
        }

        container.register(ArtistDetailsRepository.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceType.self)!
            let storageService = resolver.resolve(StorageService.self)!
            let reachability = resolver.resolve(ReachabilityService.self)!
            return ArtistDetailsRepository(networkService: networkService, storageService: storageService, reachability: reachability)
        }
    }
}
