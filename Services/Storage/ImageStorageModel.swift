//
//  StoredImageModel.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 31.03.2021.
//

import RealmSwift
import Foundation

final class ImageStorageModel: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var size: String = ""
    
    convenience init(imageType: ImageType) {
        self.init()
        url = imageType.url.absoluteString
        size = imageType.size.rawValue
    }
}
