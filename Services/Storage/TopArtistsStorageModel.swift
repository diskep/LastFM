//
//  TopArtistsStorageModel.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import Foundation
import RealmSwift

final class TopArtistStorageModel: Object {
    @objc dynamic var country: String = ""
    let artists = List<ArtistStorageModel>()
    
    override class func primaryKey() -> String? {
        "country"
    }
    
    convenience init(country: Country, artists: [Artist]) {
        self.init()
        self.country = country.rawValue
        self.artists.append(objectsIn: artists.map(ArtistStorageModel.init))
    }
}
