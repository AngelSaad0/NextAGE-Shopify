//
//  AddAddressViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 04/09/2024.
//

import UIKit

class AddAddressViewController: UIViewController {
    @IBOutlet var cornerRaduisView:[UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Address"
        for view in cornerRaduisView {
            view.addCornerRadius(radius: 12)
        }
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

    @IBAction func addAddressButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

