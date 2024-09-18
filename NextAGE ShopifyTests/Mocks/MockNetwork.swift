//
//  MockNetwork.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 15/09/2024.
//

import Foundation
import Alamofire

@testable import NextAGE_Shopify

class MockNetworkManager: NetworkManagerProtocol {
    var fetchDataResult: Any?
    var postDataResult: Any?
    var postWithoutResponseCalled = false
    var updateDataCalled = false
    var deleteDataCalled = false
    

}

extension MockNetworkManager {
    
    func fetchData<T: Codable>(from url: String, responseType: T.Type, headers: HTTPHeaders, completion: @escaping (T?) -> Void) {
        
        if let result = fetchDataResult as? T {
            completion(result)
        } else {
            completion(nil)
        }
    }
    
    func postData<T: Codable>(to url: String, responseType: T.Type, parameters: Parameters, completion: @escaping (T?) -> Void) {
        if let result = postDataResult as? T {
            completion(result)
        } else {
            completion(nil)
        }
    }
    
    func postWithoutResponse(to url: String, parameters: Parameters) {
        postWithoutResponseCalled = true
    }
    
    func updateData(at url: String, with parameters: Parameters, completion: @escaping () -> ()) {
        updateDataCalled = true
        completion()
    }
    
    func deleteData(at url: String, completion: @escaping () -> ()) {
        deleteDataCalled = true
        completion()
    }
}
