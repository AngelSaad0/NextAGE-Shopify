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
    @IBOutlet var skipButton: UIButton!

    // MARK: -  Properties
    private var viewModel:AuthOptionsViewModel!

    // MARK: -  View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuthOptionsViewModel()
        setupBindings()
        setupViewModel()


    }

    // MARK: -  private Method

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

    // MARK: -  Action Button
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
