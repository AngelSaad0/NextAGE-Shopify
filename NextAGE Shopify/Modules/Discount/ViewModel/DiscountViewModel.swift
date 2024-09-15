//
//  DiscountViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 08/09/2024.
//

import Foundation

class DiscountViewModel {
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let userDefaultManager: UserDefaultsManager
    private var isApplied = false
    private var subTotal: Double = 0.0
    private var discountAmount: Double = 0.0
    private var priceRule: PriceRule?
    var shoppingCart: [LineItem] = []
    
    // MARK: - Closures
    var setIndicator: (Bool)->() = {_ in}
    var displayMessage: (ValidMessage, Bool)->() = {_, _ in}
    var bindResultToCollectionView: ()->() = {}
    var discountApplied: (Bool)->() = {_ in}
    var getDiscountTitle: ()->(String?) = {return ""}
    var bindSubtotalPrice: (String)->() = {_ in}
    var bindDiscountPrice: (String)->() = {_ in}
    var bindTotalPrice: (String)->() = {_ in}
    var bindAddressDetails: (String)->() = {_ in}
    
    // MARK: - Initializer
    init() {
        networkManager = NetworkManager.shared
        userDefaultManager = UserDefaultsManager.shared
    }
    
    // MARK: - Public Methods
    func fetchShoppingCart() {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultManager.shoppingCartID).shopifyURLString(), responseType: DraftOrderWrapper.self, headers: []) { result in
            self.shoppingCart = result?.draftOrder.lineItems ?? []
            self.getAddressDetails(address: result?.draftOrder.shippingAddress)
            if self.shoppingCart.first?.variantID == nil {
                self.shoppingCart = Array(self.shoppingCart.dropFirst())
            }
            self.setIndicator(false)
            self.calcTotal()
            self.bindResultToCollectionView()
        }
    }
    
    func submitDiscount(completion: @escaping ()->()) {
        var discountParameters: [String: String] = [:]
        if let priceRule = priceRule {
            discountParameters = [
                "value": priceRule.value.replacingOccurrences(of: "-", with: ""),
                "title": priceRule.title,
                "value_type": priceRule.valueType
            ]
        }
        networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultManager.shoppingCartID).shopifyURLString(), with: ["draft_order": ["applied_discount": discountParameters]]) {
            completion()
        }
    }
    
    func applyDiscount() {
        if !isApplied {
            let title = getDiscountTitle()
            guard title != "" else {
                displayMessage(.discountCodeEmpty, true)
                return
            }
            networkManager.fetchData(from: ShopifyAPI.priceRule(title: title ?? "nil").shopifyURLString(), responseType: PriceRules.self, headers: []) { result in
                guard let priceRule = result?.priceRules.first else {
                    self.displayMessage(.discountCodeFailed, true)
                    return
                }
                self.priceRule = priceRule
                self.discountAmount = Double(priceRule.value) ?? 0
                self.calcTotal()
                self.displayMessage(.discountCodeApplied, false)
                self.isApplied.toggle()
                self.discountApplied(true)
            }
        } else {
            priceRule = nil
            isApplied.toggle()
            discountAmount = 0
            calcTotal()
            discountApplied(false)
        }
    }
    
    // MARK: - Private Methods
    private func calcSubTotal() {
        subTotal = 0.0
        for product in shoppingCart {
            subTotal += (Double(product.price) ?? 0.0) * Double(product.quantity)
        }
        bindSubtotalPrice(exchange(subTotal) + " \(UserDefaultsManager.shared.currency)")
    }
    
    private func calcTotal() {
        calcSubTotal()
        if priceRule?.valueType == "fixed_amount" {
            bindDiscountPrice(String(format: "%.2f", discountAmount) + " \(UserDefaultsManager.shared.currency)")
            bindTotalPrice(String((Double(exchange(subTotal)) ?? 0.0) + Double(discountAmount)) + " \(UserDefaultsManager.shared.currency)")
        } else {
            bindDiscountPrice(String(format: "%.2f", (Double(exchange(subTotal)) ?? 0.0) * Double(discountAmount) / 100) + " \(UserDefaultsManager.shared.currency)")
            bindTotalPrice(String(format: "%.2f", (Double(exchange(subTotal)) ?? 0.0) * (1 + Double(discountAmount) / 100)) + " \(UserDefaultsManager.shared.currency)")
        }
    }
    
    private func getAddressDetails(address: ShippingAddress?) {
        if let shippingAddress = address {
            bindAddressDetails("\(shippingAddress.address1 ?? "his address")\n\(shippingAddress.firstName ?? "customer") \(shippingAddress.phone ?? "")")
        } else {
            bindAddressDetails("")
        }
    }
}
