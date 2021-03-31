//
//  ServicesAssembly.swift
//  LastFM
//
//  Created by Timur Mustafaev on 29.03.2021.
//

import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        registerNetworkService(in: container)
        registerStorageService(in: container)
        registerReachabilityService(in: container)
    }
    
    private func registerNetworkService(in container: Container) {
        container.register(NetworkServiceType.self) { _ in
            NetworkService()
        }.inObjectScope(.container)
    }
    
    private func registerStorageService(in container: Container) {
        container.register(StorageService.self) { _ in
            StorageService()
        }.inObjectScope(.container)
    }
    
    private func registerReachabilityService(in container: Container) {
        container.register(ReachabilityService.self) { _ in
            ReachabilityService()
        }.inObjectScope(.container)
    }
}
