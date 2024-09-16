//
//  ShopingCartViewModelTests.swift
//  NextAGE ShopifyTests
//
//  Created by Mohamed Ayman on 16/09/2024.
//

import XCTest
@testable import NextAGE_Shopify

final class ShopingCartViewModelTests: XCTestCase {
    var viewModel : ShoppingCartViewModel?
    override func setUpWithError() throws {
        viewModel = ShoppingCartViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testCheckInternetConnectionWithConnection() {
        viewModel?.checkInternetConnection()
        
        viewModel?.fetchShoppingCart()
        viewModel?.removeProduct(at: 1)
        
        
        
    }}
