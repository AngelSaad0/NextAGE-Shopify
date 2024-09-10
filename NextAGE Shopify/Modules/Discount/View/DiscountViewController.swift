//
//  DiscountViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 04/09/2024.
//

import UIKit

class DiscountViewController: UIViewController {
    var isApplied = false
    
    @IBOutlet var selectAddressButton: UIButton!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var applyDiscountButton: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    private let indicator = UIActivityIndicatorView(style: .large)
    private let networkManager: NetworkManager
    private let userDefaultManager: UserDefaultManager
    private var shoppingCart: [LineItem] = []
    private var subTotal: Double = 0.0
    private var discountAmount: String = "0.0"
    
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
    
    private func updateUI() {
        title = "Review"
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        selectAddressButton.addCornerRadius(radius: 12)
        applyDiscountButton.addCornerRadius(radius: 12)
        setupIndicator()
        productsCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
    }

    private func setupIndicator() {
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    private func calcSubTotal() {
        subTotal = 0.0
        for product in shoppingCart {
            subTotal += (Double(product.price) ?? 0.0) * Double(product.quantity)
        }
        subtotalLabel.text = String(format: "%.2f", subTotal) + " \(UserDefaultManager.shared.currency)"
    }
    
    private func calcTotal() {
        calcSubTotal()
        #warning("fetch discount")
        discountLabel.text = String(format: "%.2f", discountAmount) + " \(UserDefaultManager.shared.currency)"
        totalLabel.text = String(format: "%.2f", subTotal + (Double(discountAmount) ?? 0.0)) + " \(UserDefaultManager.shared.currency)"
    }
    
    private func fetchShoppingCart() {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultManager.shoppingCartID).shopifyURLString(), responseType: DraftOrderWrapper.self) { result in
            self.shoppingCart = result?.draftOrder.lineItems ?? []
            if self.shoppingCart.first?.variantID == nil {
                self.shoppingCart = Array(self.shoppingCart.dropFirst())
            }
            self.indicator.stopAnimating()
            self.calcTotal()
            self.productsCollectionView.reloadData()
        }
    }
    
    @IBAction func applyDiscountButton(_ sender: Any) {
        isApplied.toggle()
        applyDiscountButton.setTitle(isApplied ? "Change" : "Apply", for: .normal)
    }
    @IBAction func selectAddressButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddressViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DiscountViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.productID = shoppingCart[indexPath.row].productID
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}

extension DiscountViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingCart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        let product = shoppingCart[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    
}

extension DiscountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 25
        return CGSize(width: width, height: collectionView.frame.height - 20)
    }
}
