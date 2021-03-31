//
//  ArtistStorageModel.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import RealmSwift
import Foundation

final class ArtistStorageModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    let images = List<ImageStorageModel>()
    @objc dynamic var listeners: String = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(artist: Artist) {
        self.init()
        id = artist.mbid
        name = artist.name
        images.append(objectsIn: artist.image.map(ImageStorageModel.init))
        listeners = artist.listeners
        
    }
}
