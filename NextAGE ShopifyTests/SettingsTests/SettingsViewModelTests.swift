//
//  SettingsTests.swift
//  NextAGE ShopifyTests
//
//  Created by Mohamed Ayman on 16/09/2024.
//

import XCTest
@testable import NextAGE_Shopify

class SettingsViewModelTests: XCTestCase {
    
    var viewModel: SettingsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SettingsViewModel()
        viewModel.isLogin()
        viewModel.settingDidSelect(at: 1)
        viewModel.navigateToAddress = {
            print("Navigate to Address")
        }
        
        viewModel.navigateToCurrency = {
            print("Navigate to Currency")
        }
        
        viewModel.navigateToAbout = {
            print("Navigate to About")
        }
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    

    func testLogout() {
        viewModel.logout()
        XCTAssertFalse(viewModel.isLogin(), "Expected isLogin to return false after logout")
    }
    
    func testGetSettingsCount() {
        XCTAssertEqual(viewModel.getSettingsCount(), 3, "Expected settings count to be 3")
    }
    
    func testGetSettingLabelAndImageName() {
        XCTAssertEqual(viewModel.getSettingLabel(index: 0), "Address", "Expected label for index 0 to be 'Address'")
        XCTAssertEqual(viewModel.getSettingImageName(index: 0), "gps", "Expected image name for index 0 to be 'gps'")
        
        XCTAssertEqual(viewModel.getSettingLabel(index: 1), "Currency", "Expected label for index 1 to be 'Currency'")
        XCTAssertEqual(viewModel.getSettingImageName(index: 1), "transfer", "Expected image name for index 1 to be 'transfer'")
        
        XCTAssertEqual(viewModel.getSettingLabel(index: 2), "About", "Expected label for index 2 to be 'About'")
        XCTAssertEqual(viewModel.getSettingImageName(index: 2), "information", "Expected image name for index 2 to be 'information'")
    }
    

}
