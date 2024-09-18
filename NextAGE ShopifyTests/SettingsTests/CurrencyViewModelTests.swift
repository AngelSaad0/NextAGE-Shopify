//
//  CurrencyViewModel.swift
//  NextAGE ShopifyTests
//
//  Created by Mohamed Ayman on 16/09/2024.
//
import XCTest
@testable import NextAGE_Shopify


class CurrencyViewModelTests: XCTestCase {
    
    var viewModel: CurrencyViewModel!


    override func setUp() {
        super.setUp()
        viewModel = CurrencyViewModel()
    
        viewModel.popView = {
            print("Pop view")
        }
        
        viewModel.setIndicator = { isLoading in
            print("Loading indicator: \(isLoading)")
        }
        
        viewModel.displayMessage = { message, _ in
            print("Display message: \(message)")
        }
    }

    override func tearDown() {
        viewModel = nil

        super.tearDown()
    }
    
    func testCurrencyDidSelect_Success() {
        let expectation = self.expectation(description: "Exchange rate fetched")
        let testCurrency = "USD"
        let expectedRate = 3.75
        viewModel.currencyDidSelect(at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
   
            XCTAssertNotNil(self.viewModel.userDefaultsManager.exchangeRate, "Expected exchange rate to be set")
            XCTAssertGreaterThan(self.viewModel.userDefaultsManager.exchangeRate, 0, "Expected exchange rate to be greater than 0")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
 
    func testCurrencyDidSelect_Failure() {
        let expectation = self.expectation(description: "Exchange rate fetch failed")
        let testCurrency = "USD"
        viewModel.currencyDidSelect(at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertEqual(self.viewModel.userDefaultsManager.currency, testCurrency, "Expected currency to be set to '\(testCurrency)'")
            XCTAssertEqual(self.viewModel.userDefaultsManager.exchangeRate, 1.0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetCurrenciesCount() {
        XCTAssertEqual(viewModel.getCurrenciesCount(), 4, "Expected currency count to be 4")
    }
    
    func testGetCurrencyLabel() {
        XCTAssertEqual(viewModel.getCurrencyLabel(at: 0), "USD", "Expected label for index 0 to be 'USD'")
        XCTAssertEqual(viewModel.getCurrencyLabel(at: 1), "EGP", "Expected label for index 1 to be 'EGP'")
    }
    
    func testIsCurrentCurrency() {
        viewModel.userDefaultsManager.currency = "USD"
        
        XCTAssertTrue(viewModel.isCurrentCurrency(at: 0), "Expected 'USD' to be the current currency for index 0")
        XCTAssertFalse(viewModel.isCurrentCurrency(at: 1), "Expected 'EGP' not to be the current currency for index 1")
    }
}
