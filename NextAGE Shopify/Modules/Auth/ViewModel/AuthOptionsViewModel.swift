//
//  AuthOptionsViewModel.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import Foundation
class AuthOptionsViewModel {

    // MARK: -  properties
    private var networkManager: NetworkManagerProtocol
    private var connectivityService: ConnectivityServiceProtocol

    // MARK: -  Closure to notify the view controller about changes
    var navigateToViewController: ((String) -> Void)?
    var setRootViewController: ((String,String)->Void)?

    // MARK: -  Initialization
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared, connectivityService: ConnectivityServiceProtocol = ConnectivityService.shared) {
        self.networkManager = networkManager
        self.connectivityService = connectivityService
    }
    // MARK: -  Methods
    func checkConnectivity( completion: @escaping (Bool) -> Void) {
        connectivityService.checkInternetConnection { isConnected in
            DispatchQueue.main.async {
                completion(isConnected)
            }
        }
    }
    func skipButtonClicked() {
        UserDefaultManager.shared.continueAsAGuest = true
        UserDefaultManager.shared.storeData()
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
            print("fff")
        }
    }
}
