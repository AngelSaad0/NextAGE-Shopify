//
//  AuthOptionsViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 02/09/2024.
//

import UIKit
import AVFoundation
class AuthOptionsViewController: UIViewController {
    // MARK: -  IBOutlet
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    // MARK: -  properties
    private var networkManager: NetworkManager
    private var connectivityService: ConnectivityServiceProtocol

    // MARK: - Required init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        connectivityService = ConnectivityService.shared
        super.init(coder: coder)
    }
    // MARK: -  View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: -  private method
    private func updateUI() {
        signInButton.addCornerRadius(radius: 16)
        signUpButton.addCornerRadius(radius: 16)
    }
    // MARK: -  Action Button
    @IBAction func skipButtonClicked(_ sender: UIButton) {
#warning("uncomment user default")
        // UserDefaultManager.shared.continueAsAGuest = true
        UserDefaultManager.shared.storeData()
        UIWindow.setRootViewController(storyboard:"MainTabBar", vcIdentifier : "MainTabBarNavigationController")

    }

    @IBAction func signInButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "SignInViewController", withNav: navigationController)
    }

    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "SignUpViewController", withNav: navigationController)
    }

}
