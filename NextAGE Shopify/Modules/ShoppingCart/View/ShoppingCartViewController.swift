//
//  ShoppingCartViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

struct DummyProduct {
    let productName: String
    let productInfo: String
    let productPrice: String
    let productImage: String
}

class ShoppingCartViewController: UIViewController {
    var dummyData = Array(repeating: DummyProduct(productName: "Adidas Halawany", productInfo: "Black", productPrice: "3197.89", productImage: "shoe.fill"), count: 10)
    
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping cart"
        
        cartTableView.delegate = self
        cartTableView.dataSource = self

        calcSubTotal()
    }
    
    func calcSubTotal() {
        var sum = 0.0
        for product in dummyData {
            sum += Double(product.productPrice) ?? 0.0
        }
        subTotalLabel.text = "Sub Total: " + sum.formatted() + " EGP"
    }
    
    @IBAction func checkoutButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShoppingCartViewController: UITableViewDelegate {
    
}

extension ShoppingCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        cell.configCell(with: dummyData[indexPath.row])
        return cell
    }
    
#warning("removing product make unexpected behavior with count")
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete product", message: "Are you sure you want to remove this product from your shopping cart?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.dummyData.remove(at: indexPath.row)
            self.calcSubTotal()
            tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        self.present(alert, animated: true)
    }
}

extension ShoppingCartViewController: UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
}
