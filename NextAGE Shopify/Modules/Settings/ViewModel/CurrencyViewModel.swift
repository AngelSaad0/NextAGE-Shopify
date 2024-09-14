//
//  CurrencyViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 08/09/2024.
//

import Foundation

class CurrencyViewModel {
    // MARK: - Properties
    let userDefaultsManager: UserDefaultsManager
    let currencies = ["USD", "EGP", "SAR", "AED"]
    
    // MARK: - Closures
    var popView: ()->() = {}
    
    // MARK: - Init
    init() {
        userDefaultsManager = UserDefaultsManager.shared
    }
    
    // MARK: - Public Methods
    func currencyDidSelect(at index: Int) {
        userDefaultsManager.currency = currencies[index]
        userDefaultsManager.storeData()
        popView()
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
}
