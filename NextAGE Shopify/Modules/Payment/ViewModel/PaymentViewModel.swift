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
    let networkManager: NetworkManagerProtocol
    let userDefaultsManager: UserDefaultsManager
    let paymentRequest: PKPaymentRequest = PKPaymentRequest()
    let paymentMethods = [
        ("Apple pay", "applePay"),
        ("Cash on delivery", "cash")
    ]
    var shoppingCartDraftOrder: DraftOrder?
    var selectedPaymentMethod = 0
    
    // MARK: - Closures
    var presentPaymentRequest: (PKPaymentRequest)->() = {_ in}
    var bindTotalAmount: (String)->() = {_ in}
    var pushConfirmationViewController: ()->() = {}
    var showFailOrderMessage: ()->() = {}
    
    // MARK: - Init
    init() {
        networkManager = NetworkManager.shared
        userDefaultsManager = UserDefaultsManager.shared
        setupPaymentRequest(request: paymentRequest)
    }
    
    // MARK: - Public Methods
    func applePay() {
        let price = String(format: "%.2f", calculateTotalPrice())
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "NextAGE New Order Payment", amount: NSDecimalNumber(string: price))]
        presentPaymentRequest(paymentRequest)
    }
    
    func purchaseOrder() {
        submitOrder { success in
            if success {
                self.clearShoppingCart(shoppingCartID: self.userDefaultsManager.shoppingCartID)
                self.pushConfirmationViewController()
            } else {
                self.showFailOrderMessage()
            }
        }
    }
    
    func fetchShoppingCart(shoppingCartID: Int) {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultsManager.shoppingCartID).shopifyURLString(), responseType: DraftOrderWrapper.self, headers: []) { result in
            self.shoppingCartDraftOrder = result?.draftOrder
            self.bindTotalAmount("Total amount: \(String(format: "%.2f", self.calculateTotalPrice())) \(self.userDefaultsManager.currency)")
        }
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
    
    
    private func submitOrder(completion: @escaping (Bool)->()) {
        networkManager.postData(to: ShopifyAPI.orders.shopifyURLString(), responseType: EmptyResponse.self, parameters: ["order": getOrderDictionary()]) { result in
            completion(result != nil)
        }
    }
    
    private func clearShoppingCart(shoppingCartID: Int) {
        networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultsManager.shoppingCartID).shopifyURLString(), with: getEmptyDraft()) { }
    }
    
    private func getCartLineItems() -> [[String: Any]] {
        var cartLineItems: [[String: Any]] = []
        for item in shoppingCartDraftOrder?.lineItems ?? [] {
            var properties : [[String: String]] = []
            if item.variantID != nil {
                for property in item.properties {
                    properties.append(["name":property.name, "value": property.value])
                }
                cartLineItems.append(["variant_id": item.variantID ?? 0, "quantity": item.quantity, "properties": properties, "product_id": item.productID ?? 0, "price": exchange(item.price)])
            }
        }
        return cartLineItems
    }
    
    private func getOrderDictionary() -> [String: Any] {
        let orderDictionary: [String: Any] = [
            "line_items": getCartLineItems(),
            "billing_address": getShippingAddressDictionary(),
            "shipping_address": getShippingAddressDictionary(),
            "currency": userDefaultsManager.currency,
            "customer": [
                "first_name": userDefaultsManager.firstName,
                "last_name": userDefaultsManager.lastName,
                "email": userDefaultsManager.email,
//                "phone": userDefaultsManager.phone
            ],
            "discount_codes": [getDiscountDictionary()],
            "total_price": exchange(shoppingCartDraftOrder?.totalPrice ?? ""),
        ]
        return orderDictionary
    }
    
    private func getShippingAddressDictionary() -> [String: Any] {
        var addressParameters: [String: Any] = [:]
        if let shippingAddress = shoppingCartDraftOrder?.shippingAddress {
            addressParameters = [
                "name": shippingAddress.firstName ?? "",
                "address1": shippingAddress.address1 ?? "",
                "phone": shippingAddress.phone ?? "",
                "city": shippingAddress.city ?? ""
            ]
        }
        return addressParameters
    }
    
    private func getDiscountDictionary() -> [String: Any] {
        var discountParameters: [String: String] = [:]
        if let priceRule = shoppingCartDraftOrder?.appliedDiscount {
            discountParameters = [
                "code": priceRule.title,
                "amount": priceRule.value.replacingOccurrences(of: "-", with: ""),
                "type": priceRule.valueType
            ]
        }
        return discountParameters
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
            totalPrice += (Double(item.price) ?? 0.0) * Double(item.quantity)
        }
        let discount = Double(shoppingCartDraftOrder?.appliedDiscount?.value ?? "0.0") ?? 0.0
        if shoppingCartDraftOrder?.appliedDiscount?.valueType == "fixed_amount" {
            return (Double(exchange(totalPrice)) ?? 0.0) - discount
        } else {
            return (Double(exchange(totalPrice)) ?? 0.0) * (1 - discount / 100)
        }
    }
}
