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
    private var rating: Double = 0
    private var selectedVariantID:Int?
    private var selectedVariantInventoryQuantity:Int?
    private var selectedColor:String?
    private var selectedSize:String?
    private var wishlist: [LineItem]?
    private var shoppingCart: [LineItem]?

    private var sizes: [String]? {
        didSet {
            configureSizeMenu()
        }
    }
    private var colors: [String]? {
        didSet {
            configureColorMenu()
        }
    }
    private var userDefaultManger:UserDefaultManager
    private var selectedButton: UIButton?
    private let selectedButtonColor = UIColor.red
    private var product: ProductInfo?
    
    // MARK: - Properties
    let indicator = UIActivityIndicatorView(style: .large)
    let networkManager: NetworkManager
    var productID: Int?
    var isFavorite = false

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        updateUI()
        fetchProduct()
        fetchDrafts()

    }


    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultManger = UserDefaultManager.shared
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
    
    private func fetchDrafts() {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultManger.shoppingCartID).shopifyURLString(), responseType: DraftOrderWrapper.self) { result in
            self.shoppingCart = result?.draftOrder.lineItems
            print("fetched shopping cart")
            print(self.shoppingCart)
        }
        
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultManger.wishlistID).shopifyURLString(), responseType: DraftOrderWrapper.self) { result in
            self.wishlist = result?.draftOrder.lineItems
            self.updateFavoriteState()
            print("fetched wishlist")
            print(self.wishlist)
        }
    }

    private func updateProductInfo() {
        viewAllReviewsButton.isEnabled = true
        productSizeButton.isEnabled = true
        productColorButton.isEnabled = true

        if let product = product {
            productTitleLabel.text = product.title
            let price = Double(product.variants.first?.price ?? "0.0") ?? 0.0
            let exchangeRate = userDefaultManger.exchangeRate
            let formattedPrice = String(format: "%.2f", exchangeRate * price)
            let currency = userDefaultManger.currency
            #warning("rating for test ")
            rating = Double(product.id % 10 + 1) / 2
            updateStars()

            productPriceLabel.text = "\(formattedPrice) \(currency)"
            productDescriptionTextView.text = product.bodyHTML
            reviewTableView.reloadData()
            productCollectionView.reloadData()
            updateDropdownOptions()
            selectedVariantID = product.variants.first?.id
            selectedVariantInventoryQuantity = product.variants.first?.inventoryQuantity
            
//            updateFavoriteState()
            

//            if let selectedSize = productSizeButton.titleLabel?.text,
//               let selectedSizeIndex = sizes?.firstIndex(of: selectedSize)
//                {
//                let variantId = product.variants[selectedSizeIndex].id
//                addToFavoriteButton.isEnabled = !userDefaultManger.shoppingCart.contains(variantId)
//            }
        }
    }
    
    private func updateFavoriteState() {
//        isFavorite = userDefaultManger.wishlist.contains(product?.id ?? 0)
        for item in wishlist ?? [] {
            if productID == item.productID {
                isFavorite = true
                break
            }
        }
        updateFavoriteImage()
    }
    
    private func updateFavoriteImage() {
        let favoriteImage = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        addToFavoriteButton.setImage(favoriteImage, for: .normal)
    }
    
    private func updateDropdownOptions() {
        var sizeOptions: [String] = []
        var colorOptions: [String] = []
        for option in product?.options ?? [] {
            if option.name == .size {
                sizeOptions = option.values
            } else if option.name == .color {
                colorOptions = option.values
            }
        }
        sizes = sizeOptions
        colors = colorOptions

        if let firstSize = sizes?.first {
            selectedSize = firstSize
            productSizeButton.setTitle(firstSize, for: .normal)
            productSizeButton.backgroundColor = UIColor(named: Colors.C0079FB.rawValue)
        }
        if let firstColor = colors?.first {
            selectedColor = firstColor
            productColorButton.setTitle(firstColor, for: .normal)
            productColorButton.backgroundColor = UIColor(named: Colors.C0079FB.rawValue)
        }
    }

    private func configureSizeMenu() {
        let actionClosure = { [weak self] (action: UIAction) in
            guard let self = self else { return }
             selectedSize = action.title
            self.productSizeButton.setTitle(action.title, for: .normal)
        }

        var menuChildren: [UIMenuElement] = []
        for size in sizes ?? [] {
            menuChildren.append(UIAction(title: size, handler: actionClosure))
        }

        productSizeButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        productSizeButton.showsMenuAsPrimaryAction = true
        productSizeButton.changesSelectionAsPrimaryAction = true
    }

    private func configureColorMenu() {
        let actionClosure = { [weak self] (action: UIAction) in
            guard let self = self else { return }
            selectedColor = action.title
            self.productColorButton.setTitle(action.title, for: .normal)
        }

        var menuChildren: [UIMenuElement] = []
        for color in colors ?? [] {
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

    private func fetchProduct() {
        guard let productID = productID else {
            print("ID not sent from previous view")
            presentError()
            return
        }
        networkManager.fetchData(from: ShopifyAPI.product(id: productID).shopifyURLString(), responseType: Product.self) { [weak self] result in
            guard let self = self else { return }
            self.indicator.stopAnimating()
            guard let product = result?.product else {
                self.presentError()
                return
            }
            self.product = product
            self.updateProductInfo()
        }
    }

    func updateSelectedVariantID() {
        if let variants = product?.variants {
            for variant in variants {
                if selectedSize == variant.option1 && selectedColor == variant.option2 {
                    selectedVariantID = variant.id
                    selectedVariantInventoryQuantity = variant.inventoryQuantity
                }
            }
        }
    }

    private func updateStars() {
        for (index, button) in productRatingButton.enumerated() {
            let starRating = Double(index + 1)
            if rating >= starRating {
                button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else if rating > starRating - 1 && rating < starRating {
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
        print(userDefaultManger.shoppingCartID)
        if userDefaultManger.isLogin {
            updateSelectedVariantID()
            let newItem: [String: Any] = [
                "variant_id": selectedVariantID ?? 0,
                "quantity" : 1,
                "properties":[
                    [
                        "name": "image",
                        "value": self.product?.image.src ?? ""
                    ],
                    [
                        "name": "inventoryQuantity",
                        "value": String(self.selectedVariantInventoryQuantity ?? 0)]]
            ]
            
            var cartLineItems: [[String: Any]] = []
            for item in shoppingCart ?? [] {
                var properties : [[String: String]] = []
                if item.variantID != nil {
                    for property in item.properties {
                        properties.append(["name":property.name, "value": property.value])
                    }
                    cartLineItems.append(["variant_id": item.variantID ?? 0, "quantity": item.quantity, "properties": properties, "product_id": item.productID ?? 0])
                }
            }
            
            cartLineItems.append(newItem)
            print("added")
            
            networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultManger.shoppingCartID).shopifyURLString(), with: ["draft_order": ["line_items": cartLineItems]]) {
                displayMessage(massage: .addedToShoppingCart, isError: false)
            }

            self.addToCartButton.setTitle("Added To Cart Successfully", for: .normal)
            self.addToCartButton.isEnabled = false
//            self.addToCartButton.alpha = 0.5
//            updateSelectedVariantID()
//            userDefaultManger.shoppingCart.append(selectedVariantID ?? 0)
//            userDefaultManger.storeData()
//            print(userDefaultManger.shoppingCart)
        } else {
            showAlert(title: "Login first", message: "You need to login in order to add this product to shopping cart", okTitle: "Login") { _ in
                self.pushViewController(vcIdentifier: "SignInViewController", withNav: self.navigationController)
            } cancelHandler: { _ in }
        }

#warning("post to draft order then append")
    }
    @IBAction func addToWishListButtonClicked(_ sender: UIButton) {
        print(userDefaultManger.wishlistID)

        if userDefaultManger.isLogin {
            if isFavorite {
//                userDefaultManger.wishlist.removeAll{$0 == product?.id}
                
                updateSelectedVariantID()
                
                var wishlistLineItems: [[String: Any]] = []
                for item in wishlist ?? [] {
                    var properties : [[String: String]] = []
                    if item.variantID != nil && item.productID != productID {
                        for property in item.properties {
                            properties.append(["name":property.name, "value": property.value])
                        }
                        wishlistLineItems.append(["variant_id": item.variantID ?? 0, "quantity": item.quantity, "properties": properties, "product_id": item.productID ?? 0])
                    }
                }
                
                if wishlistLineItems.isEmpty {
                    wishlistLineItems = [[
                        "title": "Empty",
                        "quantity": 1,
                        "price": "0",
                        "properties":[]
                    ]]
                }
                
                networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultManger.wishlistID).shopifyURLString(), with: ["draft_order": ["line_items": wishlistLineItems]]) {
                    displayMessage(massage: .removedFromWishlist, isError: false)
                    self.isFavorite = false
                    self.updateFavoriteImage()
                }
                
                
                
                
                
                
            } else {
                updateSelectedVariantID()
                let newItem: [String: Any] = [
                    "variant_id": selectedVariantID ?? 0,
                    "quantity" : 1,
                    "properties":[
                        [
                            "name": "image",
                            "value": self.product?.image.src ?? ""
                        ],
                        [
                            "name": "inventoryQuantity",
                            "value": String(self.selectedVariantInventoryQuantity ?? 0)]]
                ]
                
                var wishlistLineItems: [[String: Any]] = []
                for item in wishlist ?? [] {
                    var properties : [[String: String]] = []
                    if item.variantID != nil {
                        for property in item.properties {
                            properties.append(["name":property.name, "value": property.value])
                        }
                        wishlistLineItems.append(["variant_id": item.variantID ?? 0, "quantity": item.quantity, "properties": properties, "product_id": item.productID ?? 0])
                    }
                }
                
                wishlistLineItems.append(newItem)
                
                networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultManger.wishlistID).shopifyURLString(), with: ["draft_order": ["line_items": wishlistLineItems]]) {
                    displayMessage(massage: .addedToWishlist, isError: false)
                    self.isFavorite = true
                    self.updateFavoriteImage()
                }
                
                
//                userDefaultManger.wishlist.append(productID ?? 0)
//                            userDefaultManger.storeData()
//                            updateFavoriteState()
            }

            
//            print(userDefaultManger.wishlist)
        } else {
            showAlert(title: "Login first", message: "You need to login in order to add this product to whishlist", okTitle: "Login") { _ in
                self.pushViewController(vcIdentifier: "SignInViewController", withNav: self.navigationController)
            } cancelHandler: { _ in }
        }
    }


}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: product!.images[indexPath.row].src))
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

