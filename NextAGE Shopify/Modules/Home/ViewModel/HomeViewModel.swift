//
//  HomeViewModel.swift
//  NextAGE Shopify
//
//  Created by Engy on 02/09/2024.
//

import Foundation

class HomeViewModel {
    // MARK: - Properties
    private let networkManager: NetworkManager
    private let userDefaultsManager: UserDefaultManager
    private let connectivityService: ConnectivityServiceProtocol

    private(set) var brandsResultArray: [SmartCollection] = []
    private var discountCodes: [String] = []
    private(set) var offersList: [String] = ["COUPON10_20_1","COUPON10_1","COUPON20_1","COUPON10_20_2","COUPON10_2","COUPON20_2","COUPON10_20_3","COUPON10_3","COUPON20_3","COUPON20_1","COUPON10_4","COUPON20_4","COUPON10_5"]
    var isLoggedIn: Bool {
        return userDefaultsManager.isLogin
    }

    // MARK: - Initialization
    init(networkManager: NetworkManager = NetworkManager(),
         userDefaultsManager: UserDefaultManager = UserDefaultManager.shared,
         connectivityService: ConnectivityServiceProtocol = ConnectivityService.shared) {
        self.networkManager = networkManager
        self.userDefaultsManager = userDefaultsManager
        self.connectivityService = connectivityService
    }

    // MARK: - Data Loading
    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        connectivityService.checkInternetConnection { isConnected in
            completion(isConnected)
        }
    }

    func loadBrands(completion: @escaping () -> Void) {
        networkManager.fetchData(from: ShopifyAPI.smartCollections.shopifyURLString(), responseType: BrandsCollection.self) { [weak self] result in
            guard let self = self, let brands = result else { return }
            self.brandsResultArray = brands.smartCollections
            completion()
        }
    }
//    func loadPriceRules(){
//        networkManager.fetchData(from: ShopifyAPI.priceRules.shopifyURLString(), responseType: PriceRules.self) { result in
//            DispatchQueue.main.async {
//                guard let priceRules = result?.priceRules else {
//                    self.adsCollectionView.displayEmptyMessage("No Discounts Available")
//                    return
//                }
//                self.discountCodes = priceRules.map {$0.title}
//                self.adsCollectionView.reloadData()
//            }
//#warning("make adsCollectionView count = discountCodes.count")
//#warning("make adsCollectionView cell image as static one")
//#warning("make adsCollectionView didSelectCell copies discountCodes[indexPath.row]")
//        }
//    }

}
