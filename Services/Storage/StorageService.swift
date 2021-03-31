//
//  StorageServiceType.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 30.03.2021.
//

import Foundation
import Combine
import RealmSwift

protocol ArtistStorageServiceType: AnyObject{
    func store(artists: [Artist], for country: Country) -> AnyPublisher<Void, Error>
    func getArtists(for country: Country) -> AnyPublisher<[ArtistStorageModel], Error>
}

protocol AlbumStorageServiceType: AnyObject {
    func store(albums: [Album], for artist: String) -> AnyPublisher<Void, Error>
    func getAlbums(for artist: String) -> AnyPublisher<[AlbumStorageModel], Error>
}

enum StorageError: Error {
    case realmNotInitialized
}

final class StorageService {
    private var realm: Realm?
    private let queue: DispatchQueue
    
    init() {
        queue = DispatchQueue(label: "com.realm.queue", qos: .background)
        queue.async {
            do {
                self.realm = try Realm(queue: self.queue)
            } catch {
                self.realm = nil
                print("Realm error \(error)")
            }
        }
    }

    private func store(object: Object) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            self?.queue.async {
                do {
                    try self?.realm?.write {
                        self?.realm?.add(object, update: .modified)
                    }
                    promise(.success(()))
                } catch {
                    print("Realm store error: \(error)")
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}

// MARK: - ArtistStorageServiceType
extension StorageService: ArtistStorageServiceType {
    func getArtists(for country: Country) -> AnyPublisher<[ArtistStorageModel], Error> {
        Future { [weak self] promise in
            self?.queue.async {
                let predicate = NSPredicate(format: "country == '\(country.rawValue)'")
                if let model = self?.realm?.objects(TopArtistStorageModel.self).filter(predicate).first {
                    promise(.success(Array(model.artists)))
                } else {
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func store(artists: [Artist], for country: Country) -> AnyPublisher<Void, Error> {
        let storageModel = TopArtistStorageModel(country: country, artists: artists)
        return store(object: storageModel)
    }
}

// MARK: - AlbumStorageServiceType
extension StorageService: AlbumStorageServiceType {
    func store(albums: [Album], for artist: String) -> AnyPublisher<(), Error> {
        let storageModel = ArtistAlbumsStorageModel(artist: artist, albums: albums)
        return store(object: storageModel)
    }

    func getAlbums(for artist: String) -> AnyPublisher<[AlbumStorageModel], Error> {
        Future { [weak self] promise in
            self?.queue.async {
                let predicate = NSPredicate(format: "artist == '\(artist)'")
                if let model = self?.realm?.objects(ArtistAlbumsStorageModel.self).filter(predicate).first {
                    promise(.success(Array(model.albums)))
                } else {
                    promise(.success([]))
                }
            }
        }.eraseToAnyPublisher()
    }
}
