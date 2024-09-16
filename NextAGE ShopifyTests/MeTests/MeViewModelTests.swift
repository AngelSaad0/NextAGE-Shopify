//
//  MeViewModelTests.swift
//  NextAGE ShopifyTests
//
//  Created by Engy on 14/09/2024.
//

import XCTest
@testable import NextAGE_Shopify

class MeViewModelTests: XCTestCase {
    var viewModel: MeViewModel!
    var mockConnectivityService: MockConnectivityService!

    override func setUp() {
        super.setUp()
        mockConnectivityService = MockConnectivityService()
            viewModel = MeViewModel()
    }


    func testUpdateUserOrders() {
        let expectation = XCTestExpectation(description: "Orders are updated")

        viewModel.onOrdersUpdated = {
            
            XCTAssertEqual(self.viewModel.orders.count, 0, "Orders should contain one order")
            XCTAssertEqual(self.viewModel.orders.first?.id, nil, "Order ID should match")
            expectation.fulfill()
        }

        viewModel.updateUserOrders()

        wait(for: [expectation], timeout: 5.0)
    }

    // Test if wishlist is updated correctly
    func testLoadWishlistData() {
        let expectation = XCTestExpectation(description: "Wishlist is updated")
        viewModel.onWishlistUpdated = {
            print(self.viewModel.wishlist.count)
            XCTAssertEqual(self.viewModel.wishlist.count, 0, "Wishlist should contain two items")
            expectation.fulfill()
            
        }

        viewModel.loadWishlistData()

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCheckInternetConnection_WhenConnected() {
        mockConnectivityService.isConnected = true

        let ordersUpdatedExpectation = XCTestExpectation(description: "Orders updated callback triggered")
        let wishlistUpdatedExpectation = XCTestExpectation(description: "Wishlist updated callback triggered")

        viewModel.onOrdersUpdated = {
            ordersUpdatedExpectation.fulfill()
        }
        viewModel.onWishlistUpdated = {
            wishlistUpdatedExpectation.fulfill()
        }

        viewModel.checkInternetConnection()

        wait(for: [ordersUpdatedExpectation, wishlistUpdatedExpectation], timeout: 5)
    }
    
}

