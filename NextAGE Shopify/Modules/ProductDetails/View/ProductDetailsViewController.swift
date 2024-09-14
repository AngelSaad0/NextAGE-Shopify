//
//  ProductDetailsViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 02/09/2024.
//

import UIKit
import Kingfisher

class ProductDetailsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var productCollectionView: UICollectionView!
    @IBOutlet var productRatingButton: [UIButton]!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productSizeButton: UIButton!
    @IBOutlet weak var productColorButton: UIButton!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet var reviewTableView: UITableView!
    @IBOutlet var viewAllReviewsButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    
    // MARK: - Properties
    let viewModel: ProductDetailsViewModel
    let indicator = UIActivityIndicatorView(style: .large)
    private var selectedButton: UIButton?
    private let selectedButtonColor = UIColor.red
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupIndicator()
        setupViewModel()
        viewModel.fetchProduct()
    }
    
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = ProductDetailsViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        title = "NextAGE"
        addToFavoriteButton.addCornerRadius(radius: 12)
        addToCartButton.addCornerRadius(radius: 12)
        productSizeButton.addCornerRadius(radius: 12)
        productColorButton.addCornerRadius(radius: 12)
        viewAllReviewsButton.addCornerRadius(radius: 12)
        reviewTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
    }
    
    private func setupIndicator() {
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    private func setupViewModel() {
        viewModel.configureSizeMenu = {
            self.configureSizeMenu()
        }
        viewModel.configureColorMenu = {
            self.configureColorMenu()
        }
        viewModel.presentError = {
            self.presentError()
        }
        viewModel.setIndicator = { state in
            DispatchQueue.main.async { [weak self] in
                if state {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }
        }
        viewModel.enableButtons = {
            self.viewAllReviewsButton.isEnabled = true
            self.productSizeButton.isEnabled = true
            self.productColorButton.isEnabled = true
        }
        viewModel.updateStars = {
            self.updateStars()
        }
        viewModel.updateDropdownOptions = {
            self.updateDropdownOptions()
        }
        viewModel.updateFavoriteImage = {
            self.updateFavoriteImage()
        }
        viewModel.didAddToCart = {
            self.addToCartButton.setTitle("Added To Cart Successfully", for: .normal)
            self.addToCartButton.isEnabled = false
        }
        viewModel.showMessage = { message, isError in
            displayMessage(massage: message, isError: isError)
        }
        viewModel.bindDataToVC = { title, price, description in
            self.productTitleLabel.text = title
            self.productPriceLabel.text = price
            self.productDescriptionTextView.text = description
            self.reviewTableView.reloadData()
            self.productCollectionView.reloadData()
        }
    }
    
    private func updateFavoriteImage() {
        let favoriteImage = UIImage(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
        addToFavoriteButton.setImage(favoriteImage, for: .normal)
    }
    
    private func updateDropdownOptions() {
        var sizeOptions: [String] = []
        var colorOptions: [String] = []
        for option in viewModel.product?.options ?? [] {
            if option.name == .size {
                sizeOptions = option.values
            } else if option.name == .color {
                colorOptions = option.values
            }
        }
        viewModel.sizes = sizeOptions
        viewModel.colors = colorOptions
        
        if let firstSize = viewModel.sizes?.first {
            viewModel.selectedSize = firstSize
            productSizeButton.setTitle(firstSize, for: .normal)
            productSizeButton.backgroundColor = UIColor(named: Colors.C0079FB.rawValue)
        }
        if let firstColor = viewModel.colors?.first {
            viewModel.selectedColor = firstColor
            productColorButton.setTitle(firstColor, for: .normal)
            productColorButton.backgroundColor = UIColor(named: Colors.C0079FB.rawValue)
        }
    }
    
    private func configureSizeMenu() {
        let actionClosure = { [weak self] (action: UIAction) in
            guard let self = self else { return }
            viewModel.selectedSize = action.title
            self.productSizeButton.setTitle(action.title, for: .normal)
        }
        
        var menuChildren: [UIMenuElement] = []
        for size in viewModel.sizes ?? [] {
            menuChildren.append(UIAction(title: size, handler: actionClosure))
        }
        
        productSizeButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        productSizeButton.showsMenuAsPrimaryAction = true
        productSizeButton.changesSelectionAsPrimaryAction = true
    }
    
    private func configureColorMenu() {
        let actionClosure = { [weak self] (action: UIAction) in
            guard let self = self else { return }
            viewModel.selectedColor = action.title
            self.productColorButton.setTitle(action.title, for: .normal)
        }
        
        var menuChildren: [UIMenuElement] = []
        for color in viewModel.colors ?? [] {
            menuChildren.append(UIAction(title: color, handler: actionClosure))
        }
        productColorButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        productColorButton.showsMenuAsPrimaryAction = true
        productColorButton.changesSelectionAsPrimaryAction = true
    }
    
    private func presentError() {
        indicator.stopAnimating()
        showAlert(title: "Error", message: "An unexpected error occurred while loading product info.", okHandler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    private func updateStars() {
        for (index, button) in productRatingButton.enumerated() {
            let starRating = Double(index + 1)
            if viewModel.rating >= starRating {
                button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else if viewModel.rating > starRating - 1 && viewModel.rating < starRating {
                button.setImage(UIImage(systemName: "star.leadinghalf.fill"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func viewAllReviewsButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "AllReviewsViewController", withNav: navigationController)
    }
    
    @IBAction func addToCartButtonClicked(_ sender: UIButton) {
        if viewModel.userDefaultManger.isLogin {
            viewModel.addToShoppingCart()
        } else {
            showLoginFirstAlert(to: "add this product to shopping cart")
        }
    }
    
    @IBAction func addToWishListButtonClicked(_ sender: UIButton) {
        if viewModel.userDefaultManger.isLogin {
            viewModel.addToWishlist()
        } else {
            showLoginFirstAlert(to: "add this product to wishlist")
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.product?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: viewModel.product!.images[indexPath.row].src))
        return cell
    }
}

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == reviewTableView {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == reviewTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            cell.configure(with: dummyReviews[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == reviewTableView {
            pushViewController(vcIdentifier: "AllReviewsViewController", withNav: navigationController)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == reviewTableView {
            return 110
        }
        return UITableView.automaticDimension
    }
}

