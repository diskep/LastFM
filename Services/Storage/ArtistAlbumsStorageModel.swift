//
// Created by Tymur Mustafaiev on 31.03.2021.
//

import Foundation
import RealmSwift

final class ArtistAlbumsStorageModel: Object {
    @objc dynamic var artist: String = ""
    let albums = List<AlbumStorageModel>()

    override class func primaryKey() -> String? {
        "artist"
    }

    convenience init(artist: String, albums: [Album]) {
        self.init()
        self.artist = artist
        let storageAlbums = albums.map { AlbumStorageModel(name: $0.name,
                                                           playCount: $0.playCount,
                                                           images: $0.image.map(ImageStorageModel.init))
        }
        self.albums.append(objectsIn: storageAlbums)
    }
}