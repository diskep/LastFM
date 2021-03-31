//
// Created by Tymur Mustafaiev on 31.03.2021.
//

import Foundation
import Combine

protocol ArtistDetailsRepositoryType {
    func getAlbums(for artist: String) -> AnyPublisher<[Album], Error>
}

final class ArtistDetailsRepository {
    private let networkService: NetworkServiceType
    private let storageService: AlbumStorageServiceType
    private let reachability: ReachabilityService
    private var useCache = false
    private var disposeBag: Set<AnyCancellable>

    init(networkService: NetworkServiceType, storageService: AlbumStorageServiceType, reachability: ReachabilityService) {
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

    private func mapAlbums(_ albums: [AlbumStorageModel]) -> [Album] {
        albums.map { album -> Album in
            let images = album.images.compactMap { image -> ImageType? in
                guard let size = ImageSize(rawValue: image.size), let url = URL(string: image.url) else { return nil }
                return ImageType(url: url, size: size)
            }
            return Album(name: album.name, playCount: album.playCount, image: Array(images))
        }
    }
}

// MARK: - TopArtistsReposotoryType
extension ArtistDetailsRepository: ArtistDetailsRepositoryType {
    func getAlbums(for artist: String) -> AnyPublisher<[Album], Error> {
        if useCache {
            return storageService.getAlbums(for: artist)
                                 .map(mapAlbums)
                                 .eraseToAnyPublisher()
        } else {
            let publisher = networkService.execute(request: LastFMTargetRequest.artistAlbums(artist: artist), with: TopAlbumsResponse.self)
                                          .subscribe(on: DispatchQueue.global(qos: .background))
                                          .map(\.albums)
                                          .share()
                                          .eraseToAnyPublisher()
            publisher.flatMap { [weak storageService] albums -> AnyPublisher<Void, Error> in
                         guard let storageService = storageService else {
                             return Fail(error: StorageError.realmNotInitialized).eraseToAnyPublisher()
                         }
                         return storageService.store(albums: albums, for: artist)
                     }
                     .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                     .store(in: &disposeBag)
            return publisher
        }
    }
}
