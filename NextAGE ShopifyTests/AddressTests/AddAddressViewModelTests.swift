//
//  AddressViewModelTests.swift
//  NextAGE ShopifyTests
//
//  Created by Mohamed Ayman on 18/09/2024.
//

import XCTest
@testable import NextAGE_Shopify

class AddAddressViewModelTests: XCTestCase {
    
    var viewModel: AddAddressViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AddAddressViewModel()
        viewModel.userDefaultsManager.customerID = 8422317261096
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testAddAddress_ShouldAddAddressSuccessfully() {
        // Arrange
        let expectation = self.expectation(description: "Add address successfully")
        
  
        viewModel.showSuccessMessage = {
            expectation.fulfill()
        }
        
        // Act
        viewModel.addAddress(name: "Mohamed Ayman", address: "Street 123", city: "Cairo", country: "Egypt", phone: "+01555555555", isDefault: false) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testEditAddress_ShouldEditAddressSuccessfully() {
        // Arrange
        // Set up an existing address to edit
        viewModel.address = Address(id: 10387805176104, customerID: 8422317261096 , address1:"123 Street", city: "Cairo", country: "Egypt", phone: "+2019999999999" ,name:"Mohamed", addressDefault: true)
        
        let expectation = self.expectation(description: "Edit address successfully")
        
        viewModel.showSuccessEditingMessage = {
            expectation.fulfill()
        }
        
        // Act
        viewModel.editAddress(name: "Mohamed", address: "456 Oak Street", city: "Cairo", country: "Egypt", phone: "+2019999999999", isDefault: false) {
            // Test completes when the success message closure is called
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
