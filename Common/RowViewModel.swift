//
//  ArtistRowViewModel.swift
//  LastFM
//
//  Created by Timur Mustafaev on 28.03.2021.
//

import Foundation

struct RowViewModel: Identifiable {
    let id: String
    let name: String
    let listeners: String
    let image: URL
}
