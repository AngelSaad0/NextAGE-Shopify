//
//  AuthOptionsViewModel.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import Foundation
class AuthOptionsViewModel {
    // MARK: - Properties
    private var networkManager: NetworkManagerProtocol
    private var connectivityService: ConnectivityServiceProtocol
    
    // MARK: - Closures
    var navigateToViewController: ((String) -> Void)?
    var setRootViewController: ((String,String)->Void)?
    
    // MARK: - Initializer
    init() {
        networkManager = NetworkManager.shared
        connectivityService = ConnectivityService.shared
    }
    
    // MARK: - Public Methods
    func checkConnectivity( completion: @escaping (Bool) -> Void) {
        connectivityService.checkInternetConnection { isConnected in
            DispatchQueue.main.async {
                completion(isConnected)
            }
        }
    }
    
    func skipButtonClicked() {
        UserDefaultsManager.shared.continueAsAGuest = true
        UserDefaultsManager.shared.storeData()
        DispatchQueue.main.async {
            self.setRootViewController?("MainTabBar","MainTabBarNavigationController")
        }
    }
    
    func signInButtonClicked() {
        DispatchQueue.main.async {
            self.navigateToViewController?("SignInViewController")
        }
    }
    
    func signUpButtonClicked() {
        DispatchQueue.main.async {
            self.navigateToViewController?("SignUpViewController")
        }
    }
}
