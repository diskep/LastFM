//
//  Artist.swift
//  LastFM
//
//  Created by Timur Mustafaev on 28.03.2021.
//

import Foundation

struct Artist: Decodable {
    let name: String
    let mbid: String
    let listeners: String
    let image: [ImageType]
}
