//
//  ConfirmationViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import UIKit

class ConfirmationViewController: UIViewController {

    @IBOutlet weak var continueShoppingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        continueShoppingButton.addCornerRadius(radius: 12)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func continueShoppingButton(_ sender: Any) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "MainTabBarNavigationController")
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
    }
}
