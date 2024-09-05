//
//  MainTabBarController.swift
//  NextAGE Shopify
//
//  Created by Engy on 02/09/2024.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var isWishList = true
    @IBOutlet var rightBarButton: UIBarButtonItem!
    @IBOutlet var searchBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    @IBAction func searchBarButtonClicked(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        if isWishList {
            print("heart.fill")
            
        } else {
            print("setting")
        }
        
    }
    @IBAction func cartButtonTapped(_ sender: UIBarButtonItem) {
        print("Cart button tapped")
    }
    
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
