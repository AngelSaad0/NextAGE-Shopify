//
//  HomeViewModel.swift
//  NextAGE Shopify
//
//  Created by Engy on 02/09/2024.
//

import Foundation

class HomeViewModel {
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let userDefaultsManager: UserDefaultsManager
    private let connectivityService: ConnectivityServiceProtocol
    private(set) var brandsResultArray: [SmartCollection] = []
    private(set) var discountCodes: [String] = []
    private(set) var offersList: [String] = ["COUPON10_1","COUPON20_1"]
    var isLoggedIn: Bool {
        return userDefaultsManager.isLogin
    }
    
    // MARK: -  Closures
    var displayEmptyMessage: (String)->() = {_ in}
    
    // MARK: - Initializer
    init() {
        networkManager = NetworkManager.shared
        userDefaultsManager = UserDefaultsManager.shared
        connectivityService = ConnectivityService.shared
    }
    
    // MARK: - Public Methods
    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        connectivityService.checkInternetConnection { isConnected in
            completion(isConnected)
        }
    }
    
    func loadBrands(completion: @escaping () -> Void) {
        networkManager.fetchData(from: ShopifyAPI.smartCollections.shopifyURLString(), responseType: BrandsCollection.self, headers: []) { [weak self] result in
            guard let self = self, let brands = result else { return }
            self.brandsResultArray = brands.smartCollections
            completion()
        }
    }
    
    func loadPriceRules(completion: @escaping () -> Void) {
        networkManager.fetchData(from: ShopifyAPI.priceRules.shopifyURLString(), responseType: PriceRules.self, headers: []) { result in
            DispatchQueue.main.async {
                guard let priceRules = result?.priceRules else {
//                    self.adsCollectionView.displayEmptyMessage("No Discounts Available")
                    return
                }
                self.discountCodes = priceRules.map {$0.title}
                completion()
            }
        }
    }
}
