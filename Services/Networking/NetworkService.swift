//
//  NetworkService.swift
//  LastFM
//
//  Created by Timur Mustafaev on 26.03.2021.
//

import Foundation
import Moya
import Combine

final class NetworkService {
    
    private let provider: MoyaProvider<LastFMTargetRequest>
    
    init() {
        #if DEBUG
        let plugins: [PluginType] = [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        #else
        let plugins: [PluginType] = []
        #endif
        provider = MoyaProvider<LastFMTargetRequest>(callbackQueue: DispatchQueue.global(qos: .background),
                                                     plugins: plugins)
    }
    
    private func execute(request: LastFMTargetRequest) -> AnyPublisher<Data, Error> {
        Future { [provider] promise in
            provider.request(request) { response in
                switch response {
                case .success(let response):
                    promise(.success(response.data))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}

// MARK - NetworkServiceType
extension NetworkService: NetworkServiceType {
    func execute<Result: Decodable>(request: LastFMTargetRequest, with type: Result.Type) -> AnyPublisher<Result, Error> {
        execute(request: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .decode(type: type, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
