//
//  AllOrdersViewmodelTests.swift
//  NextAGE ShopifyTests
//
//  Created by Engy on 15/09/2024.
//

import XCTest
@testable import NextAGE_Shopify

class AllOrdersViewModelIntegrationTests: XCTestCase {

    var viewModel: AllOrdersViewModel!

    override func setUp() {
        super.setUp()
        // Initialize the view model with real instances of dependencies
        viewModel = AllOrdersViewModel()
        // Optionally set up any necessary real data or state
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testCheckInternetConnectionWhenConnected() {
        // Given
        let expectation = self.expectation(description: "updateUserOrders called")
        viewModel.bindResultToTableView = {
            expectation.fulfill()
        }
        
        // When
        viewModel.checkInternetConnection()
        
        // Then
        waitForExpectations(timeout: 10.0) { error in
            XCTAssertNil(error, "Expectation timed out: \(String(describing: error))")
        }
    }


}
