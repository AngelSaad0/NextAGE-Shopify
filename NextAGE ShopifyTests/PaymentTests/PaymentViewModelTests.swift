////
////  PaymentViewModelTests.swift
////  NextAGE ShopifyTests
////
////  Created by Mohamed Ayman on 16/09/2024.
////
//
//import XCTest
//
//import PassKit
//@testable import  NextAGE_Shopify
//
//
//class PaymentViewModelTests: XCTestCase {
//    
//    var viewModel: PaymentViewModel!
//    var userDefaultsManager: UserDefaultsManager!
//    var networkManager: NetworkManager!
//    
//    override func setUp() {
//        super.setUp()
//        
//        // Initialize real instances for testing
//        networkManager = NetworkManager.shared
//        userDefaultsManager = UserDefaultsManager.shared
//        viewModel = PaymentViewModel()
//        
//        // Set up closures to observe behavior
//        viewModel.presentPaymentRequest = { request in
//            print("Presenting payment request: \(request)")
//        }
//        
//        viewModel.pushConfirmationViewController = {
//            print("Push confirmation view controller")
//        }
//        
//        viewModel.showFailOrderMessage = {
//            print("Show fail order message")
//        }
//        
//    
//        userDefaultsManager.shoppingCartID = 123 // Example ID
//        userDefaultsManager.currency = "USD"
//        userDefaultsManager.firstName = "John"
//        userDefaultsManager.lastName = "Doe"
//        userDefaultsManager.email = "john.doe@example.com"
//    }
//
//    override func tearDown() {
//        viewModel = nil
//        networkManager = nil
//        userDefaultsManager = nil
//        super.tearDown()
//    }
//    
//    // Test `applePay` functionality
//    func testApplePay() {
//        // Assuming that the `presentPaymentRequest` closure should be called
//        viewModel.applePay()
//        
//        // You would typically need to verify if the `presentPaymentRequest` closure was called.
//        // Since it's a closure, you might need to use a test-specific approach to verify its call.
//    }
//    
//    // Test `purchaseOrder` with a successful submission
//    func testPurchaseOrder_Success() {
//        let expectation = self.expectation(description: "Order submitted successfully")
//        
//        viewModel.submitOrder { success in
//            XCTAssertTrue(success, "Expected order submission to succeed")
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//    
//    // Test `purchaseOrder` with a failed submission
//    func testPurchaseOrder_Failure() {
//        let expectation = self.expectation(description: "Order submission failed")
//        
//        // Simulate failure in network manager if possible
//        // This assumes that you have a way to simulate failure in the real implementation
//        viewModel.submitOrder { success in
//            XCTAssertFalse(success, "Expected order submission to fail")
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//    
//    // Test `getCartLineItems`
//    func testGetCartLineItems() {
//        // Set up test data for shoppingCartDraftOrder
//        viewModel.shoppingCartDraftOrder = DraftOrder(lineItems: [
//            LineItem(variantID: 1, quantity: 2, properties: [], productID: 1, price: "10.0"),
//            LineItem(variantID: 2, quantity: 1, properties: [], productID: 2, price: "20.0")
//        ], appliedDiscount: nil, shippingAddress: nil, totalPrice: "30.0")
//        
//        let lineItems = viewModel.getCartLineItems()
//        
//        XCTAssertEqual(lineItems.count, 2, "Expected 2 line items")
//        XCTAssertEqual(lineItems[0]["variant_id"] as? Int, 1, "Expected variant_id to be 1")
//        XCTAssertEqual(lineItems[0]["quantity"] as? Int, 2, "Expected quantity to be 2")
//        XCTAssertEqual(lineItems[0]["price"] as? String, "10.0", "Expected price to be '10.0'")
//    }
//    
//    // Test `calculateTotalPrice`
//    func testCalculateTotalPrice() {
//        viewModel.shoppingCartDraftOrder = DraftOrder(lineItems: [
//            LineItem(variantID: 1, quantity: 2, properties: [], productID: 1, price: "10.0"),
//            LineItem(variantID: 2, quantity: 1, properties: [], productID: 2, price: "20.0")
//        ], appliedDiscount: Discount(title: "Discount", value: "5.0", valueType: "fixed_amount"), shippingAddress: nil, totalPrice: "30.0")
//        
//        let totalPrice = viewModel.calculateTotalPrice()
//        
//        XCTAssertEqual(totalPrice, 35.0, "Expected total price to be 35.0")
//    }
//}
