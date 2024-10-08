//
//  SettingsViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import Foundation
import FirebaseAuth

class SettingsViewModel {
    // MARK: - Properties
    let userDefaultsManager: UserDefaultsManager
    let settingsLabelImageOptions = [
        ("Address", "gps"),
        ("Currency", "transfer"),
        ("About", "information")
    ]
    
    // MARK: - Closures
    var navigateToAddress: ()->() = {}
    var navigateToCurrency: ()->() = {}
    var navigateToAbout: ()->() = {}
    
    // MARK: - Init
    init() {
        userDefaultsManager = UserDefaultsManager.shared
    }
    
    // MARK: - Public Methods
    func isLogin() -> Bool {
        return userDefaultsManager.isLogin
    }
    
    func logout() {
        userDefaultsManager.logout()
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func getSettingsCount() -> Int {
        return settingsLabelImageOptions.count
    }
    
    func getSettingLabel(index: Int) -> String {
        return settingsLabelImageOptions[index].0
    }
    
    func getSettingImageName(index: Int) -> String {
        return settingsLabelImageOptions[index].1
    }
    
    func settingDidSelect(at index: Int) {
        switch index {
        case 0:
            navigateToAddress()
        case 1:
            navigateToCurrency()
        default:
            navigateToAbout()
        }
    }
}
