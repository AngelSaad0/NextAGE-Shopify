//
//  AboutViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

class AboutViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 20
    }
}
