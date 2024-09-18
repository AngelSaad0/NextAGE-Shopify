//
//  MainTabBarController.swift
//  NextAGE Shopify
//
//  Created by Engy on 02/09/2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    var isWishList = true
    // MARK: - IBOutlets
    @IBOutlet var rightBarButton: UIBarButtonItem!
    @IBOutlet var searchBarButton: UIBarButtonItem!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
        
    // MARK: - IBActions
    @IBAction func searchBarButtonClicked(_ sender: UIBarButtonItem) {
        pushViewController(vcIdentifier: "SearchViewController", withNav: navigationController)
    }

    @IBAction func rightButtonClicked(_ sender: Any) {
        if isWishList {
            if UserDefaultsManager.shared.isLogin {
                pushViewController(vcIdentifier: "WishlistViewController", withNav: navigationController)
            } else {
                showLoginFirstAlert(to: "view your wishlist")
            }
        } else {
            pushViewController(vcIdentifier: "SettingsViewController", withNav: navigationController)
        }
    }
    
    @IBAction func cartButtonTapped(_ sender: UIBarButtonItem) {
        if UserDefaultsManager.shared.isLogin {
            pushViewController(vcIdentifier: "ShoppingCartViewController", withNav: navigationController)
        } else {
            showLoginFirstAlert(to: "view your shopping cart")
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else { return }

        if selectedIndex == 0 || selectedIndex == 1 {
            rightBarButton.image = UIImage(systemName: "heart.fill")
            searchBarButton.customView = nil
            isWishList = true
        } else if selectedIndex == 2 {
            rightBarButton.image = UIImage(systemName: "gearshape.fill")
            searchBarButton.customView = UIView()
            isWishList = false
        }
    }
}
