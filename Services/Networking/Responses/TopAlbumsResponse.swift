//
//  TopAlbumsResponse.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import Foundation

struct TopAlbumsResponse: Decodable {
    let albums: [Album]
    
    private enum CodingKeys: String, CodingKey {
        case albums = "topalbums"
    }
    
    private struct TopAlbums: Decodable {
        let album: [Album]
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let topAlbums = try container.decode(TopAlbums.self, forKey: .albums)
        albums = topAlbums.album
    }
}
