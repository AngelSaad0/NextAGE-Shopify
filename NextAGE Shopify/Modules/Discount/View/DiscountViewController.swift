//
//  DiscountViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 04/09/2024.
//

import UIKit

class DiscountViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var selectPaymentMethodButton: UIButton!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var applyDiscountButton: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    // MARK: - Properties
    let viewModel: DiscountViewModel
    private let indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Required Initializer
    required init?(coder: NSCoder) {
        viewModel = DiscountViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
        setupKeyboardDismissal()
        viewModel.fetchShoppingCart()
    }
    
    private func updateUI() {
        title = "Review"
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        applyDiscountButton.addCornerRadius(radius: 12)
        setupIndicator()
        productsCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
    }
    
    private func setupIndicator() {
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    private func setupViewModel() {
        viewModel.setIndicator = { state in
            DispatchQueue.main.async { [weak self] in
                state ? self?.indicator.startAnimating() : self?.indicator.stopAnimating()
            }
        }
        viewModel.bindResultToCollectionView = {
            DispatchQueue.main.async { [weak self] in
                self?.productsCollectionView.reloadData()
            }
        }
        viewModel.discountApplied = { state in
            DispatchQueue.main.async { [weak self] in
                if state {
                    self?.applyDiscountButton.setTitle("Change", for: .normal)
                    self?.discountTextField.isEnabled = false
                } else {
                    self?.applyDiscountButton.setTitle("Apply", for: .normal)
                    self?.discountTextField.isEnabled = true
                }
            }
        }
        viewModel.displayMessage = { massage, isError in
            displayMessage(massage: massage, isError: isError)
        }
        viewModel.getDiscountTitle = {
            return self.discountTextField.text?.trimmingCharacters(in: .whitespaces)
        }
        viewModel.bindSubtotalPrice = { subtotal in
            self.subtotalLabel.text = subtotal
        }
        viewModel.bindDiscountPrice = { discount in
            self.discountLabel.text = discount
        }
        viewModel.bindTotalPrice = { total in
            self.totalLabel.text = total
        }
    }
    
    // MARK: - IBActions
    @IBAction func applyDiscountButton(_ sender: Any) {
        viewModel.applyDiscount()
    }
    
    @IBAction func selectPaymentMethodButtonClicked(_ sender: Any) {
        viewModel.submitDiscount {
            self.pushViewController(vcIdentifier: "PaymentViewController", withNav: self.navigationController)
        }
    }
}

extension DiscountViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.viewModel.productID = viewModel.shoppingCart[indexPath.row].productID
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}

extension DiscountViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.shoppingCart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        let product = viewModel.shoppingCart[indexPath.row]
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
