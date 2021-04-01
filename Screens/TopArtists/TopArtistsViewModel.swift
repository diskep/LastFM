//
//  TopArtistsViewModel.swift
//  LastFM
//
//  Created by Timur Mustafaev on 28.03.2021.
//

import Combine
import Foundation

final class TopArtistsViewModel {
    
    @Published private(set) var state: ViewState<[RowViewModel]> = .loading
    @Published private(set) var country: String = Country.ukraine.rawValue.capitalized
    
    private let repository: TopArtistsRepositoryType
    private var disposeBag: Set<AnyCancellable>
    private var isViewLoaded = false
    
    init(repository: TopArtistsRepositoryType) {
        self.repository = repository
        disposeBag = Set<AnyCancellable>()
    }
    
    private func fetchArtists(for country: Country) {
        state = .loading
        repository.getTopArtists(for: country)
            .map {
                $0.compactMap { artist -> RowViewModel? in
                    guard let image = artist.image.first else { return nil }
                    let formattedListeners = NumberFormatter.format(listeners: artist.listeners)
                    return RowViewModel(id: artist.mbid, name: artist.name, listeners: "Listeners: \(formattedListeners)", image: image.url)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.state = .error
                default: break
                }
            } receiveValue: { [weak self] rows in
                self?.state = .data(rows)
            }
            .store(in: &disposeBag)
    }
    
}

// MARK: - TopArtistsViewModelType

extension TopArtistsViewModel: TopArtistsViewModelType {
    func didChange(country: Country) {
        self.country = country.rawValue.capitalized
        fetchArtists(for: country)
    }
    
    func didLoad() {
        guard !isViewLoaded else { return }
        isViewLoaded = true
        
        fetchArtists(for: .ukraine)
    }

}
