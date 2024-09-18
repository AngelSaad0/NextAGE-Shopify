//
//  DiscountTests.swift
//  NextAGE ShopifyTests
//
//  Created by Mohamed Ayman on 18/09/2024.
//

import XCTest
@testable import  NextAGE_Shopify

class DiscountViewModelTests: XCTestCase {
    
    var viewModel: DiscountViewModel!
    
    override func setUp() {
        super.setUp()
        
        // Initialize the view model with real dependencies
        viewModel = DiscountViewModel()
        UserDefaultsManager.shared.shoppingCartID = 1186896347432
        viewModel.applyDiscount()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchShoppingCart_ShouldRetrieveShoppingCart() {
        // Arrange
        let expectation = self.expectation(description: "Fetch shopping cart from network")

        viewModel.setIndicator = { isLoading in
            XCTAssertFalse(isLoading, "Indicator should be false after fetching shopping cart")
        }
        
        viewModel.bindResultToCollectionView = {
            XCTAssertGreaterThan(self.viewModel.shoppingCart.count, 0, "Shopping cart should contain items")
            expectation.fulfill()
        }

        // Act
        viewModel.fetchShoppingCart()
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testSubmitDiscount_ShouldSubmitDiscountSuccessfully() {
        // Arrange

        let expectation = self.expectation(description: "Submit discount successfully")
        
        viewModel.setIndicator = { isLoading in
            XCTAssertFalse(isLoading, "Indicator should be false after submitting discount")
        }
        
        // Act
        viewModel.submitDiscount {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    

}
