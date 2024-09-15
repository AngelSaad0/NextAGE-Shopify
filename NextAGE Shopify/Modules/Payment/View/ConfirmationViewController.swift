//
//  ConfirmationViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import UIKit

class ConfirmationViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var continueShoppingButton: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        self.navigationItem.hidesBackButton = true
        continueShoppingButton.addCornerRadius(radius: 12)
    }
    
    // MARK: - IBActions
    @IBAction func continueShoppingButton(_ sender: Any) {
        UIWindow.setRootViewController(vcIdentifier: "MainTabBarNavigationController")
    }
}
