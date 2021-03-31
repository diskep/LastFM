//
//  LastFMTargetRequest.swift
//  LastFM
//
//  Created by Timur Mustafaev on 26.03.2021.
//

import Moya
import Foundation

enum LastFMTargetRequest {
    case topArtists(country: Country)
    case artistAlbums(artist: String)
}

// MARK: - NetworkTargetRequestType
extension LastFMTargetRequest: NetworkTargetRequestType {
    var method: Moya.Method {
        .get
    }
    
    var baseURL: URL {
        URL(string:"https://ws.audioscrobbler.com/2.0/")!
    }
    
    var task: Task {
        .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var params: [String : Any] {
        var mutableParams = [String: Any]()
        switch self {
        case .topArtists(let country):
            mutableParams = ["method": "geo.gettopartists", "country": country]
        case .artistAlbums(let artist):
            mutableParams = ["method": "artist.gettopalbums", "artist": artist]
        }
        mutableParams.merge(requiredParams) { _, value in value }
        return mutableParams
    }
}
