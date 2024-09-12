//
//  PaymentViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var purchase: UIButton!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var paymentMethodsTableView: UITableView!
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
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultsManager = UserDefaultManager.shared
        super.init(coder: coder)
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupPaymentRequest(request: paymentRequest)
        fetchShoppingCart(shoppingCartID: userDefaultsManager.shoppingCartID)
    }
    // MARK: - Private Methods
    private func updateUI() {
        title = "Payment method"
        purchase.isEnabled = false
        paymentMethodsTableView.delegate = self
        paymentMethodsTableView.dataSource = self
        purchaseButton.addCornerRadius(radius: 12)
    }
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
    private func applePay() {
        let price = String(calculateTotalPrice())
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "NextAGE order", amount: NSDecimalNumber(string: price))]
        if let paymentController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
            paymentController.delegate = self
            present(paymentController, animated: true)
        }
    }
    private func purchaseOrder() {
        submitOrder()
        clearShoppingCart(shoppingCartID: userDefaultsManager.shoppingCartID)
        pushViewController(vcIdentifier: "ConfirmationViewController", withNav: navigationController)
    }
    private func submitOrder() {
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
        let orderDictionary: [String: Any] = [
            "line_items": cartLineItems,
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
        networkManager.postWithoutResponse(to: ShopifyAPI.orders.shopifyURLString(), parameters: ["order": orderDictionary])
    }
    private func clearShoppingCart(shoppingCartID: Int) {
        let shoppingCartLineItems = [[
            "title": "Test",
            "quantity": 1,
            "price": "0",
            "properties":[]
        ]]
        networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultsManager.shoppingCartID).shopifyURLString(), with: ["draft_order": ["line_items":shoppingCartLineItems]]) {
        }
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
    // MARK: - IBActions
    @IBAction func purchaseButton(_ sender: Any) {
        switch selectedPaymentMethod {
        case 0:
            applePay()
        default:
            purchaseOrder()
        }
    }
}

extension PaymentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in paymentMethods.indices {
            (tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! PaymentMethodCell).deselect()
        }
        (tableView.cellForRow(at: indexPath) as! PaymentMethodCell).select()
        selectedPaymentMethod = indexPath.row
        purchase.isEnabled = true
    }
}

extension PaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentMethodCell
        cell.config(methodName: paymentMethods[indexPath.row].0, methodImageName: paymentMethods[indexPath.row].1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        self.purchaseOrder()
    }
}

