//
//  TopArtistsResponse.swift
//  LastFM
//
//  Created by Timur Mustafaev on 28.03.2021.
//

import Foundation

struct TopArtistsResponse: Decodable {
    let artists: [Artist]
    
    private enum CodingKeys: String, CodingKey {
        case artists = "topartists"
    }
    
    private struct TopArtists: Decodable {
        let artist: [Artist]
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let topArtists = try container.decode(TopArtists.self, forKey: .artists)
        artists = topArtists.artist
    }
}
