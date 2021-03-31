//
//  NetworkTargetType.swift
//  LastFM
//
//  Created by Timur Mustafaev on 26.03.2021.
//

import Moya
import Foundation

protocol NetworkTargetRequestType: TargetType {
    var params: [String: Any] { get }
    var requiredParams: [String: Any] { get }
}

extension NetworkTargetRequestType {
    var path: String { "" }
    var validationType: Moya.ValidationType { .successCodes }
    var sampleData: Data { Data() }
    var headers: [String : String]? { nil }
    var requiredParams: [String: Any] {
        ["format": "json", "api_key": Constants.apiKey]
    }
}

