//
//  Album.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import Foundation

struct Album: Decodable {
    let name: String
    let playCount: Int
    let image: [ImageType]
    
    private enum CodingKeys: String, CodingKey {
        case name, image
        case playCount = "playcount"
    }
    
}
