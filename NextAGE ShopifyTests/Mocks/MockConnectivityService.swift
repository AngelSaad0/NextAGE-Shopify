//
//  MockConnectivityService.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 15/09/2024.
//

import Foundation
@testable import NextAGE_Shopify

class MockConnectivityService: ConnectivityServiceProtocol {
    
    var isConnected: Bool = true
    
    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion(self.isConnected)
        }
    
    }
}
