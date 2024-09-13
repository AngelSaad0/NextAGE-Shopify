//
//  SearchViewModel.swift
//  NextAGE Shopify
//
//  Created by Engy on 08/09/2024.
//

import Foundation
class SearchViewModel {
    // MARK: -  Properties
    var products: [ProductInfo] = []
    var filteredProducts: [ProductInfo] = []
    var searchKeyword: String = ""
    var isSearching: Bool = false
    var networkManager: NetworkManagerProtocol
    var connectivityService: ConnectivityServiceProtocol
    
    // MARK: - Closures
    var showNoInternetAlert: ()->() = {}
    var configureColorMenu: ()->() = {}
    var bindTablView:()->() = {}
    var activityIndicator: (Bool)->() = {_ in }
    var displayEmptyMessage: (String)->() = {_ in }
    var removeEmptyMessage: ()->() = {}
    
    // MARK: - Initializer
    init() {
        networkManager = NetworkManager.shared
        connectivityService = ConnectivityService.shared
    }
    
    // MARK: -  Public Method
    func checkInternetConnection() {
        connectivityService.checkInternetConnection { [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                self.loadProducts()
            } else {
                self.showNoInternetAlert()
            }
        }
    }
    
    func searchProducts(with searchText: String) {
        if isSearching {
            if searchText.isEmpty {
                filteredProducts = products
            } else {
                filteredProducts = products.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            filteredProducts = products
        }
        updateUIForNoResults()
        bindTablView()
    }
    
    // MARK: - Private Methods
    private func loadProducts() {
        networkManager.fetchData(from: ShopifyAPI.products.shopifyURLString(), responseType: Products.self, headers: []) { result in
            guard let products = result else { return }
            DispatchQueue.main.async { [weak self] in
                self?.products = products.products
                self?.filteredProducts = self?.products ?? []
                self?.bindTablView()
                self?.activityIndicator(false)
            }
        }
    }
    
    private func updateUIForNoResults() {
        if filteredProducts.isEmpty {
            displayEmptyMessage("No items found")
        } else {
            removeEmptyMessage()
        }
    }
    
}
