//
//  DiscountViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 04/09/2024.
//

import UIKit

class DiscountViewController: UIViewController {
    var isApplied = false
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var applyDiscount: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Review"
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
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

    @IBAction func applyDiscountButton(_ sender: Any) {
        isApplied.toggle()
        applyDiscount.setTitle(isApplied ? "Change" : "Apply", for: .normal)
    }
    @IBAction func selectAddressButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ShoppingCart", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddressViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DiscountViewController: UICollectionViewDelegate {
    
}

extension DiscountViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}

extension DiscountViewController: UICollectionViewDelegateFlowLayout {
    
}
