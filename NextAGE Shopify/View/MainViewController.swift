//
//  MainViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/1/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var SignInBtn: UIButton!
    @IBOutlet var SignUpBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        updatUI()


    }
    func updatUI(){
        SignInBtn.addCornerRadius(radius: 12)
        SignUpBtn.addCornerRadius(radius: 12)


    }

    @IBAction func SignInBtnPressed(_ sender: UIButton) {
        print("SignInBtnPressed")
    }
    

    @IBAction func SignUpBtnPressed(_ sender: UIButton) {
        print("SignUpBtnPressed")

    }


    @IBAction func SkipBtnPressed(_ sender: UIButton) {
        print("SkipBtnPressed")

    }
    
}
