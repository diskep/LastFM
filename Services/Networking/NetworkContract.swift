//
//  NetworkContract.swift
//  LastFM
//
//  Created by Timur Mustafaev on 28.03.2021.
//

import Moya
import Combine

protocol NetworkServiceType {
    func execute<Result: Decodable>(request: LastFMTargetRequest, with type: Result.Type) -> AnyPublisher<Result, Error>
}
