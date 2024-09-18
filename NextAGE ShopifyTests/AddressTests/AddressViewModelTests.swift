//
//  AddressViewModelTests.swift
//  NextAGE ShopifyTests
//
//  Created by Mohamed Ayman on 18/09/2024.
//

import XCTest
@testable import NextAGE_Shopify



final class AddressViewModelTests: XCTestCase {
    
    var viewModel: AddressViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AddressViewModel()
        
        viewModel.userDefaultsManager.customerID = 8422317261096
        viewModel.newDefaultAddressIndex = 0
        viewModel.checkInternetConnection()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testCheckInternetConnection_WhenOnline_ShouldFetchAddresses() {
        // Arrange
        let expectation = self.expectation(description: "Fetch addresses from network")
        
        // Assuming online, trigger fetchAddresses
        viewModel.connectivityService.checkInternetConnection { isConnected in
            if isConnected {
                // Act
                self.viewModel.fetchAddresses()
                expectation.fulfill()
            } else {
                XCTFail("Expected to be online")
            }
        }

        waitForExpectations(timeout: 10 , handler: nil)
    }
    
    
    func testSubmitAddress_ShouldSubmitSelectedAddress() {
        let expectation = self.expectation(description: "Submit selected address")
        
        // Simulate selecting the address for the order
        viewModel.selectedOrderAddress = 0
        viewModel.addresses = [
            Address(id: 10387805176104, customerID: 8422317261096 , address1:"019999999999", city: "123 Street", country: "New York", phone: "019999999999" ,name:"Ahmedt", addressDefault:false)
        ]
        
        // Act
        viewModel.submitAddress {
            XCTAssertTrue(true, "Address should be submitted successfully")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
