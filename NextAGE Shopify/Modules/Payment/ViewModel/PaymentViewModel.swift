//
//  PaymentViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import Foundation
import PassKit

class PaymentViewModel {
    // MARK: - Properties
    let networkManager: NetworkManager
    let userDefaultsManager: UserDefaultManager
    let paymentRequest: PKPaymentRequest = PKPaymentRequest()
    let paymentMethods = [
        ("Apple pay", "applePay"),
        ("Cash on delivery", "cash")
    ]
    var shoppingCartDraftOrder: DraftOrder?
    var selectedPaymentMethod = 0
    
    // MARK: - Closures
    var presentPaymentRequest: (PKPaymentRequest)->() = {_ in}
    var pushConfirmationViewController: ()->() = {}
    
    // MARK: - Init
    init() {
        networkManager = NetworkManager()
        userDefaultsManager = UserDefaultManager.shared
        setupPaymentRequest(request: paymentRequest)
        fetchShoppingCart(shoppingCartID: userDefaultsManager.shoppingCartID)
    }
    
    // MARK: - Public Methods
    func applePay() {
        let price = String(calculateTotalPrice())
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "NextAGE order", amount: NSDecimalNumber(string: price))]
        presentPaymentRequest(paymentRequest)
    }
    
    func purchaseOrder() {
        submitOrder()
        clearShoppingCart(shoppingCartID: userDefaultsManager.shoppingCartID)
        pushConfirmationViewController()
    }
    
    // MARK: - Private Methods
    private func setupPaymentRequest(request: PKPaymentRequest) {
        request.merchantIdentifier = "merchant.com.my.shopify.pay"
        request.supportedNetworks = [.visa, .masterCard]
        request.merchantCapabilities = .threeDSecure
        request.supportedCountries = ["EG", "US"]
        request.countryCode = "EG"
        request.currencyCode = userDefaultsManager.currency
    }
    
    private func fetchShoppingCart(shoppingCartID: Int) {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultsManager.shoppingCartID).shopifyURLString(), responseType: DraftOrderWrapper.self) { result in
            self.shoppingCartDraftOrder = result?.draftOrder
        }
    }
    
    private func submitOrder() {
        networkManager.postWithoutResponse(to: ShopifyAPI.orders.shopifyURLString(), parameters: ["order": getOrderDictionary()])
    }
    
    private func clearShoppingCart(shoppingCartID: Int) {
        networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultsManager.shoppingCartID).shopifyURLString(), with: getEmptyDraft()) {
        }
    }
    
    private func getCartLineItems() -> [[String: Any]] {
        var cartLineItems: [[String: Any]] = []
        for item in shoppingCartDraftOrder?.lineItems ?? [] {
            var properties : [[String: String]] = []
            if item.variantID != nil {
                for property in item.properties {
                    properties.append(["name":property.name, "value": property.value])
                }
                cartLineItems.append(["variant_id": item.variantID ?? 0, "quantity": item.quantity, "properties": properties, "product_id": item.productID ?? 0])
            }
        }
        return cartLineItems
    }
    
    private func getOrderDictionary() -> [String: Any] {
        let orderDictionary: [String: Any] = [
            "line_items": getCartLineItems(),
            "currency": userDefaultsManager.currency,
            "customer": [
//                "first_name": userDefaultsManager.firstName,
//                "last_name": userDefaultsManager.lastName,
                "email": userDefaultsManager.email,
//                "phone": userDefaultsManager.phone
            ],
            "applied_discount": [
                "value": shoppingCartDraftOrder?.appliedDiscount?.value,
                "value_type": shoppingCartDraftOrder?.appliedDiscount?.valueType ?? "percentage",
                "description": shoppingCartDraftOrder?.appliedDiscount?.description
            ],
            "total_price": shoppingCartDraftOrder?.totalPrice ?? ""
        ]
        return orderDictionary
    }
    
    private func getEmptyDraft() -> [String: Any] {
        let shoppingCartLineItems = [[
            "title": "Empty",
            "quantity": 1,
            "price": "0",
            "properties":[]
        ]]
        return ["draft_order": ["line_items":shoppingCartLineItems]]
    }
    
    private func getFilteredCart() -> [LineItem] {
        guard let shoppingCart = shoppingCartDraftOrder?.lineItems else { return [] }
        return shoppingCart.filter { $0.variantID != nil }
    }
    
    private func calculateTotalPrice() -> Double {
        let shoppingCart = getFilteredCart()
        var totalPrice = 0.0
        for item in shoppingCart {
            totalPrice += userDefaultsManager.exchangeRate * (Double(item.price) ?? 0.0) * Double(item.quantity)
        }
        return totalPrice
    }
}
