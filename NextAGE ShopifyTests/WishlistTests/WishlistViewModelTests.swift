//
//  WishlistViewModelTests.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 16/09/2024.
//

import XCTest
@testable import NextAGE_Shopify
final class WishlistViewModelTests: XCTestCase {
    
    var viewModel: WishlistViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = WishlistViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    func testCheckInternetConnection_WhenConnected_ShouldFetchWishlist() {
        let exp = expectation(description: "Fetching wishlist after checking internet connection")
        var didFulfill = false
                viewModel.bindResultToTableView = {
            if !didFulfill {
                XCTAssertFalse(self.viewModel.wishlist.isEmpty, "Wishlist should be fetched and contain items")
                exp.fulfill() // Fulfill the expectation when the wishlist is updated
                didFulfill = true
            }
        }
                viewModel.displayEmptyMessage = { message in
            if !didFulfill {
                XCTAssertEqual(message, "Add some products to your wishlist", "Should display empty message if wishlist is empty")
                exp.fulfill() // Fulfill the expectation when the empty message is shown
                didFulfill = true
            }
        }
        
        viewModel.checkInternetConnection()
                waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Timeout error: \(error.localizedDescription)")
            }
        }
    }}
