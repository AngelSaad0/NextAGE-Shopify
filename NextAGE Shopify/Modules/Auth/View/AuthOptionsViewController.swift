//
//  AuthOptionsViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 02/09/2024.
//

import UIKit

class AuthOptionsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var skipButton: UIButton!

    // MARK: -  Properties
    private let viewModel: AuthOptionsViewModel

    // MARK: - Initializer
    required init?(coder: NSCoder) {
        viewModel = AuthOptionsViewModel()
        super.init(coder: coder)
    }

    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupViewModel()
    }

    // MARK: - Private Method
    private func setupViewModel() {
        viewModel.navigateToViewController = { [weak self] viewControllerName in
            self?.pushViewController(vcIdentifier: viewControllerName, withNav: self?.navigationController)
        }
        viewModel.setRootViewController = { storyboard,vcIdentifier in
            UIWindow.setRootViewController(storyboard: "Main", vcIdentifier: "MainTabBarNavigationController")
        }
    }

    private func  setupBindings(){
        viewModel.checkConnectivity { [weak self] isConnected in
            if !isConnected {
                self!.showNoInternetAlert()
            }
        }
    }
    
    private func handleConnectivity(action: @escaping() -> Void) {
        viewModel.checkConnectivity { [weak self] isConnected in
            DispatchQueue.main.async {
                if isConnected {
                    action()
                } else {
                    self?.showNoInternetAlert()
                }
            }
        }
    }

    // MARK: - IBActions
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        handleConnectivity {
            self.viewModel.skipButtonClicked()
        }
    }

    @IBAction func signInButtonClicked(_ sender: UIButton) {
        handleConnectivity {
            self.viewModel.signInButtonClicked()
        }
    }

    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        handleConnectivity {
            self.viewModel.signUpButtonClicked()
        }
    }
}
