//
//  Reachability.swift
//  LastFM
//
//  Created by Tymur Mustafaiev on 31.03.2021.
//

import Foundation
import Network
import Combine

protocol Reachability {
    var isNetworkAvailable: Bool { get }
    
    func startMonitoring() -> AnyPublisher<Bool, Never>
    func stopMonitoring()
}

final class ReachabilityService {
    private let network: NWPathMonitor
    let subject: CurrentValueSubject<Bool, Never>
    private var isMonitoring = false
    
    init() {
        network = NWPathMonitor()
        subject = CurrentValueSubject<Bool, Never>(network.currentPath.status == .satisfied)
    }
}

// MARK: - Reachability
extension ReachabilityService: Reachability {
    
    var isNetworkAvailable: Bool {
        network.currentPath.status == .satisfied
    }
    
    func startMonitoring() -> AnyPublisher<Bool, Never> {
        guard !isMonitoring else {
            return subject.eraseToAnyPublisher()
        }
        isMonitoring = true
        network.pathUpdateHandler = { [weak subject] path in
            subject?.send(path.status == .satisfied)
        }
        network.start(queue: DispatchQueue.global())
        return subject.eraseToAnyPublisher()
    }
    
    func stopMonitoring() {
        isMonitoring = false
        network.cancel()
    }
    
}
