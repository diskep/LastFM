//
//  TopArtistsRepositoryType.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import Foundation
import Combine

protocol TopArtistsRepositoryType {
    func getTopArtists(for country: Country) -> AnyPublisher<[Artist], Error>
}

final class TopArtistsRepository {
    private let networkService: NetworkServiceType
    private let storageService: ArtistStorageServiceType
    private let reachability: ReachabilityService
    private var useCache = false
    private var disposeBag: Set<AnyCancellable>

    init(networkService: NetworkServiceType, storageService: ArtistStorageServiceType, reachability: ReachabilityService) {
        self.networkService = networkService
        self.storageService = storageService
        self.reachability = reachability
        useCache = !reachability.isNetworkAvailable
        disposeBag = Set<AnyCancellable>()
        observeNetworkStatus()
    }

    private func observeNetworkStatus() {
        reachability.startMonitoring()
                    .receive(on: DispatchQueue.main)
                    .map { !$0 }
                    .assign(to: \.useCache, on: self)
                    .store(in: &disposeBag)
    }

    private func mapArtists(_ artists: [ArtistStorageModel]) -> [Artist] {
        artists.map { artist -> Artist in
            let images = artist.images.compactMap { image -> ImageType? in
                guard let size = ImageSize(rawValue: image.size), let url = URL(string: image.url) else { return nil }
                return ImageType(url: url, size: size)
            }
            return Artist(name: artist.name, mbid: artist.id,
                          listeners: artist.listeners,
                          image: Array(images))
        }
    }

    private func loadArtists(for country: Country) -> AnyPublisher<[Artist], Error> {
        storageService.getArtists(for: country)
                      .map(mapArtists)
                      .eraseToAnyPublisher()
    }

    private func loadCachedArtists(for country: Country) -> AnyPublisher<[Artist], Error> {
        let publisher = networkService.execute(request: LastFMTargetRequest.topArtists(country: .ukraine), with: TopArtistsResponse.self)
                                      .map(\.artists)
                                      .share()
                                      .eraseToAnyPublisher()

        publisher.flatMap { [weak storageService] artists -> AnyPublisher<Void, Error> in
                     guard let storageService = storageService else {
                         return Fail(error: StorageError.realmNotInitialized).eraseToAnyPublisher()
                     }
                     return storageService.store(artists: artists, for: country)
                 }
                 .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                 .store(in: &disposeBag)
        return publisher
    }
}

// MARK: - TopArtistsReposotoryType
extension TopArtistsRepository: TopArtistsRepositoryType {
    func getTopArtists(for country: Country) -> AnyPublisher<[Artist], Error> {
        if useCache {
            return loadArtists(for: country)
        } else {
            return loadCachedArtists(for: country)
        }
    }
}
