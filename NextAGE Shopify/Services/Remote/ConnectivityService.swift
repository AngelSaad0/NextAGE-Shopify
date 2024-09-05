//
//  ConnectivityService.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/4/24.
//

import Foundation
import Network
protocol ConnectivityServiceProtocol {
    func checkInternetConnection(completion: @escaping (Bool) -> Void)
}

class ConnectivityService: ConnectivityServiceProtocol {
    static let shared = ConnectivityService()
    private init() {}
    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                completion(path.status == .satisfied)
                monitor.cancel()
            }
        }
        monitor.start(queue: .main)
    }
}
