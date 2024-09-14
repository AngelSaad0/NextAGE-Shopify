//
//  CurrencyViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 08/09/2024.
//

import Foundation

class CurrencyViewModel {
    // MARK: - Properties
    let networkManager: NetworkManagerProtocol
    let userDefaultsManager: UserDefaultsManager
    let currencies = ["USD", "EGP", "SAR", "AED"]
    
    // MARK: - Closures
    var popView: ()->() = {}
    var setIndicator: (Bool)->() = {_ in}
    var displayMessage: (ValidMessage, Bool)->() = {_, _ in}
    
    // MARK: - Init
    init() {
        networkManager = NetworkManager.shared
        userDefaultsManager = UserDefaultsManager.shared
    }
    
    // MARK: - Public Methods
    func currencyDidSelect(at index: Int) {
        setIndicator(true)
        getExchangeRate(to: currencies[index]) { result in
            self.setIndicator(false)
            guard let result = result else {
                self.displayMessage(.exchangeRateFailed, true)
                return
            }
            self.userDefaultsManager.currency = self.currencies[index]
            self.userDefaultsManager.exchangeRate = result
            self.userDefaultsManager.storeData()
            self.popView()
            print(self.userDefaultsManager.currency)
            print(self.userDefaultsManager.exchangeRate)
        }
    }
    
    func getCurrenciesCount() -> Int {
        return currencies.count
    }
    
    func getCurrencyLabel(at index: Int) -> String {
        return currencies[index]
    }
    
    func isCurrentCurrency(at index: Int) -> Bool {
        return userDefaultsManager.currency == currencies[index]
    }
    
    // MARK: - Private Methods
    private func getExchangeRate(to currency: String, completion: @escaping (Double?)->()) {
        networkManager.fetchData(from: CurrencyDataAPI.exchange(to: currency).URLString(), responseType: CurrencyData.self, headers: CurrencyDataAPI.header) { result in
            completion(result?.result)
        }
    }
}
