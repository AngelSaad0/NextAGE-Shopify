//
//  PaymentViewModelTests.swift
//  NextAGE ShopifyTests
//
//  Created by Mohamed Ayman on 16/09/2024.
//

import XCTest
@testable import NextAGE_Shopify

// Test class for PaymentViewModel
class PaymentViewModelTests: XCTestCase {
    
    var paymentViewModel: PaymentViewModel!
    
    override func setUp() {
        super.setUp()
        // Initialize the PaymentViewModel
        paymentViewModel = PaymentViewModel()
 
        
        paymentViewModel.applePay()
        paymentViewModel.purchaseOrder()
    }
    override func tearDown() {
        paymentViewModel = nil
        super.tearDown()
        
    }
    
    
    func testFetchShoppingCart() {
        let expectation = self.expectation(description: "Fetch shopping cart from network")
        
        paymentViewModel.bindTotalAmount = { _ in
            guard let shoppingCart = self.paymentViewModel.shoppingCartDraftOrder else {
                XCTFail("Shopping cart is nil after fetching.")
                expectation.fulfill()
                return
            }
            
            print("Shopping Cart Data: \(shoppingCart)")
            print("End of Shopping Cart Data")
            XCTAssertNotEqual(shoppingCart.totalPrice, "0.00", "Fetched shopping cart total price is incorrect.")
            expectation.fulfill()
        }
        
        paymentViewModel.fetchShoppingCart(shoppingCartID: 1186896347432)
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    
    
}
