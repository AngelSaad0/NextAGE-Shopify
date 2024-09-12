//
//  ShoppingCartViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

class ShoppingCartViewController: UIViewController {
    
    @IBOutlet var reviewButton: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    
    private let indicator = UIActivityIndicatorView(style: .large)
    private let networkManager: NetworkManager
    private let userDefaultManager: UserDefaultManager
    private var shoppingCart: [LineItem] = []
    
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultManager = UserDefaultManager.shared
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        fetchShoppingCart()
    }
    private func updateUI(){
        title = "Shopping cart"
        cartTableView.delegate = self
        cartTableView.dataSource = self
        reviewButton.addCornerRadius(radius: 12)
        updateReviewButtonState()
        setupIndicator()
    }
    
    private func updateReviewButtonState() {
        reviewButton.isEnabled = !shoppingCart.isEmpty
    }
    
    private func setupIndicator() {
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    private func fetchShoppingCart() {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultManager.shoppingCartID).shopifyURLString(), responseType: DraftOrderWrapper.self) { result in
            self.shoppingCart = result?.draftOrder.lineItems ?? []
            if self.shoppingCart.first?.variantID == nil {
                self.shoppingCart = Array(self.shoppingCart.dropFirst())
            }
            self.indicator.stopAnimating()
            self.calcSubTotal()
            self.updateReviewButtonState()
            self.cartTableView.reloadData()
            print("fetched shopping cart")
            print(self.shoppingCart)
        }
    }
    
    private func removeProduct(at index: Int) {
        var shoppingCartLineItems: [[String: Any]] = []
        for item in shoppingCart {
            var properties : [[String: String]] = []
            if item.variantID != shoppingCart[index].variantID {
                for property in item.properties {
                    properties.append(["name":property.name, "value": property.value])
                }
                shoppingCartLineItems.append(["variant_id": item.variantID ?? 0, "quantity": item.quantity, "properties": properties, "product_id": item.productID ?? 0])
            }
        }
        
        if shoppingCartLineItems.isEmpty {
            shoppingCartLineItems = [[
                "title": "Empty",
                "quantity": 1,
                "price": "0",
                "properties":[]
            ]]
        }
        
        networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultManager.shoppingCartID).shopifyURLString(), with: ["draft_order": ["line_items": shoppingCartLineItems]]) {
            displayMessage(massage: .removedFromShoppingCart, isError: false)
            self.fetchShoppingCart()
        }
    }
    
    private func calcSubTotal() {
        var sum = 0.0
        for product in shoppingCart {
            sum += (Double(product.price) ?? 0.0) * Double(product.quantity)
        }
        subTotalLabel.text = "Subtotal: " + String(format: "%.2f", sum) + " \(UserDefaultManager.shared.currency)"
    }
    
    private func showRemoveAlert(index: Int) {
        let alert = UIAlertController(title: "Delete product", message: "Are you sure you want to remove this product from your shopping cart?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.removeProduct(at: index)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction func checkoutButton(_ sender: Any) {
        pushViewController(vcIdentifier: "DiscountViewController", withNav: navigationController)
    }
}

extension ShoppingCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.productID = shoppingCart[indexPath.row].productID
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShoppingCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        cell.configCell(with: shoppingCart[indexPath.row])
        cell.deleteButton = {
            self.showRemoveAlert(index: indexPath.row)
        }
        cell.recalculateSum = {
            self.fetchShoppingCart()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.showRemoveAlert(index: indexPath.row)
    }
}

extension ShoppingCartViewController: UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
