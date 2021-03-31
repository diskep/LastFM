//
//  ImageType.swift
//  LastFM
//
//  Created by Timur Mustafaev on 28.03.2021.
//

import Foundation

struct ImageType: Decodable {
    let url: URL
    let size: ImageSize
    
    init(url: URL, size: ImageSize) {
        self.url = url
        self.size = size
    }
    
    private enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size = "size"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            url = try container.decode(URL.self, forKey: .url)
        } catch {
            url = URL(string: "https://lastfm.freetls.fastly.net/i/u/300x300/2a96cbd8b46e442fc41c2b86b821562f.png")!
            // by some reasons last.fm does not have urls for some artwork. I suggested to use dummy image for that
        }
        
        size = try container.decode(ImageSize.self, forKey: .size)
    }
    
}

enum ImageSize: String, Decodable {
    case small, medium, large, extralarge, mega
}
