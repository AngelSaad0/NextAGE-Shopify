//
//  ShoppingCartViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

class ShoppingCartViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var reviewButton: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    
    // MARK: - Properties
    let viewModel: ShoppingCartViewModel
    private let indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Required Initializer
    required init?(coder: NSCoder) {
        viewModel = ShoppingCartViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
        viewModel.checkInternetConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.checkInternetConnection()
    }
    
    // MARK: - Private Methods
    private func updateUI(){
        title = "Shopping cart"
        cartTableView.delegate = self
        cartTableView.dataSource = self
        updateReviewButtonState()
        setupIndicator()
    }
    
    private func setupViewModel() {
        viewModel.showNoInternetAlert = {
            self.showNoInternetAlert()
        }
        viewModel.setIndicator = { state in
            DispatchQueue.main.async {
                state ? self.indicator.startAnimating() : self.indicator.stopAnimating()
            }
        }
        viewModel.updateReviewButtonState = {
            DispatchQueue.main.async {
                self.updateReviewButtonState()
            }
        }
        viewModel.bindResultToTableView = {
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
        }
        viewModel.displayMessage = { massage, isError in
            displayMessage(massage: massage, isError: isError)
        }
        viewModel.bindSubtotalPrice = { subtotal in
            DispatchQueue.main.async {
                self.subTotalLabel.text = subtotal
            }
        }
        viewModel.displayEmptyMessage = { message in
            self.cartTableView.displayEmptyMessage(message)
        }
        viewModel.removeEmptyMessage = {
            self.cartTableView.removeEmptyMessage()
        }
    }
    
    private func updateReviewButtonState() {
        reviewButton.isEnabled = !viewModel.shoppingCart.isEmpty
    }
    
    private func setupIndicator() {
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    private func showRemoveAlert(index: Int) {
        showAlert(title: "Delete product", message: "Are you sure you want to remove this product from your shopping cart?", okTitle: "Yes", cancelTitle: "No", okStyle: .destructive, cancelStyle: .cancel) { _ in
            self.viewModel.removeProduct(at: index)
        } cancelHandler: {_ in}
    }
    
    @IBAction func checkoutButton(_ sender: Any) {
        pushViewController(vcIdentifier: "DiscountViewController", withNav: navigationController)
    }
}

extension ShoppingCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.viewModel.productID = viewModel.shoppingCart[indexPath.row].productID
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShoppingCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shoppingCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        cell.configCell(with: viewModel.shoppingCart[indexPath.row])
        cell.deleteButton = {
            self.showRemoveAlert(index: indexPath.row)
        }
        cell.recalculateSum = {
            self.viewModel.fetchShoppingCart()
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
