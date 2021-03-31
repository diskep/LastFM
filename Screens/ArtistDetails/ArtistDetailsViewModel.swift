//
//  ArtistDetailsViewModel.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import Foundation
import Combine

final class ArtistDetailsViewModel {
    @Published var state: ViewState<[RowViewModel]> = .loading
    @Published var selectedAlbum: AlbumViewModel?
    
    let artist: String
    
    private var albums: [RowViewModel] = []
    private let repository: ArtistDetailsRepositoryType
    private var disposeBag: Set<AnyCancellable>
    private var isLoaded = false
    
    init(artist: String, repository: ArtistDetailsRepositoryType) {
        self.repository = repository
        self.artist = artist
        disposeBag = Set<AnyCancellable>()
    }
}

// MARK: - ArtistDetailsViewModelType
extension ArtistDetailsViewModel: ArtistDetailsViewModelType {
    func didLoad() {
        guard !isLoaded else { return }
        isLoaded = true
        state = .loading

        repository.getAlbums(for: artist)
            .map { albums in
                albums.enumerated().compactMap { item -> RowViewModel? in
                    guard let image = item.element.image.first(where: { $0.size == .large }) else { return nil }
                    let formattedListeners = NumberFormatter.format(number: item.element.playCount)
                    return RowViewModel(id: String(item.offset), name: item.element.name,
                                        listeners: "Plays count: \(formattedListeners)",
                                        image: image.url)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.state = .error
                default: break
                }
            }, receiveValue: { [weak self] rows in
                self?.albums = rows
                self?.didSelect(albumId: rows.first?.id)
                self?.state = .data(rows)
            })
            .store(in: &disposeBag)
    }
    
    func didSelect(albumId: String?) {
        let album = albums.first { $0.id == albumId }
        selectedAlbum = album.map { AlbumViewModel(name: $0.name, imageUrl: $0.image, playsCount: "Plays count: \($0.listeners)") }
    }
}
