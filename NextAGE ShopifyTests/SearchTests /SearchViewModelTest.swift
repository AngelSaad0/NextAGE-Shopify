//
//  SearchViewModelTest.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 14/09/2024.
//

import XCTest
@testable import NextAGE_Shopify


class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    var networkManager: NetworkManager!
    var connectivityServiceMock: MockConnectivityService!
    
    override func setUp() {
        super.setUp()
        
        // Initialize and assign network manager and connectivity service
        networkManager = NetworkManager.shared
        connectivityServiceMock = MockConnectivityService()
        viewModel = SearchViewModel()
        viewModel.networkManager = networkManager
        viewModel.connectivityService = connectivityServiceMock
        
        // Ensure proper initialization
        XCTAssertNotNil(viewModel.networkManager, "NetworkManager should not be nil")
        XCTAssertNotNil(viewModel.connectivityService, "ConnectivityService should not be nil")
    }
    
    override func tearDown() {
        viewModel = nil
        networkManager = nil
        connectivityServiceMock = nil
        super.tearDown()
    }
    
    
    //this works with
    func testCheckInternetConnection_WithInternet() {
        // Arrange
        let expectation = self.expectation(description: "Internet connection check should succeed")
        
        connectivityServiceMock.checkInternetConnection { isConnected in
            XCTAssertTrue(isConnected, "Internet connection should be available")
            expectation.fulfill()
        }
        
        // Act
        viewModel.checkInternetConnection()
        
        // Assert
        waitForExpectations(timeout: 1, handler: nil)
    }
    func testCheckInternetConnection_WithNoInterNet() {
        // Arrange
        let expectation = self.expectation(description: "Internet connection check should succeed")
        connectivityServiceMock.isConnected = false
        connectivityServiceMock.checkInternetConnection { isConnected in
            XCTAssertFalse(isConnected, "")
            expectation.fulfill()
        }
        
        // Act
        viewModel.checkInternetConnection()
        
        // Assert
        waitForExpectations(timeout: 1, handler: nil)
    }
   /*func searchProducts(with searchText: String) {
        if isSearching {
            if searchText.isEmpty {
                filteredProducts = products
            } else {
                filteredProducts = products.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            filteredProducts = products
        }
        updateUIForNoResults()
        bindTableView()
    }*/
    
    func testSearchProducts_ifThereIsText(){
    
        //arrang
        viewModel.isSearching = true
        viewModel.products = [DummyData.dummyProduct]
        
        //act
        viewModel.searchProducts(with: "Sample Product")
        //assert
    }
    
}
