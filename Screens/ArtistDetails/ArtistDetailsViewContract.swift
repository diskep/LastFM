//
//  ArtistDetailsViewContract.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import Foundation

protocol ArtistDetailsViewModelType: ObservableObject {
    var selectedAlbum: AlbumViewModel? { get }
    var state: ViewState<[RowViewModel]> { get }
    var artist: String { get }
    
    func didLoad()
    func didSelect(albumId: String?)
}

struct AlbumViewModel {
    let name: String
    let imageUrl: URL
    let playsCount: String
}

