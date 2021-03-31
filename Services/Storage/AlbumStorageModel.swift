//
// Created by Tymur Mustafaiev on 31.03.2021.
//

import Foundation
import RealmSwift

final class AlbumStorageModel: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var playCount: Int = 0
    let images = List<ImageStorageModel>()

    convenience init(name: String, playCount: Int, images: [ImageStorageModel]) {
        self.init()
        self.name = name
        self.playCount = playCount
        self.images.append(objectsIn: images)
    }
}