//
//  ProductDetailsViewModel.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 02/09/2024.
//
import Foundation

class ProductDetailsViewModel {
    // MARK: - Properties
    let networkManager: NetworkManagerProtocol
    let userDefaultManger:UserDefaultsManager
    private var selectedVariantID:Int?
    private var selectedVariantInventoryQuantity:Int?
    var selectedColor:String?
    var selectedSize:String?
    var rating: Double = 0
    var productID: Int?
    var wishlist: [LineItem]?
    var shoppingCart: [LineItem]?
    var product: Product?
    var isFavorite = false
    var sizes: [String]? {
        didSet {
            configureSizeMenu()
        }
    }
    var colors: [String]? {
        didSet {
            configureColorMenu()
        }
    }
    
    // MARK: - Closures
    var configureSizeMenu: ()->() = {}
    var configureColorMenu: ()->() = {}
    var presentError: ()->() = {}
    var setIndicator: (Bool)->() = {_ in}
    var enableButtons: ()->() = {}
    var updateStars: ()->() = {}
    var updateDropdownOptions: ()->() = {}
    var updateFavoriteImage: ()->() = {}
    var didAddToCart: ()->() = {}
    var didFoundInCart: ()->() = {}
    var showMessage: (ValidMessage, Bool)->() = {_, _ in}
    var bindDataToVC: (String, String, String)->() = {_, _, _ in}
    
    // MARK: - Init
    init() {
        networkManager = NetworkManager.shared
        userDefaultManger = UserDefaultsManager.shared
        if userDefaultManger.isLogin {
            fetchDrafts()
        }
    }
    
    // MARK: - Public Methods
    func fetchDrafts() {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultManger.shoppingCartID).shopifyURLString(), responseType: DraftOrderWrapper.self, headers: []) { result in
            self.shoppingCart = result?.draftOrder.lineItems
        }
        
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultManger.wishlistID).shopifyURLString(), responseType: DraftOrderWrapper.self, headers: []) { result in
            self.wishlist = result?.draftOrder.lineItems
            self.updateFavoriteState()
        }
    }
    
    func fetchProduct() {
        guard let productID = productID else {
            presentError()
            return
        }
        networkManager.fetchData(from: ShopifyAPI.product(id: productID).shopifyURLString(), responseType: ProductWrapper.self, headers: []) { [weak self] result in
            guard let self = self else { return }
            setIndicator(false)
            guard let product = result?.product else {
                self.presentError()
                return
            }
            self.product = product
            self.updateProductInfo()
        }
    }
    
    func addToShoppingCart() {
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
            if item.variantID == nil {
            } else if item.variantID == selectedVariantID {
                self.showMessage(.foundInShoppingCart, false)
                didFoundInCart()
                return
            } else {
                for property in item.properties {
                    properties.append(["name":property.name, "value": property.value])
                }
                cartLineItems.append(["variant_id": item.variantID ?? 0, "quantity": item.quantity, "properties": properties, "product_id": item.productID ?? 0])
            }
        }
        cartLineItems.append(newItem)
        networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultManger.shoppingCartID).shopifyURLString(), with: ["draft_order": ["line_items": cartLineItems]]) {
            self.showMessage(.addedToShoppingCart, false)
        }
        didAddToCart()
    }
    
    func addToWishlist() {
        if isFavorite {
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
                self.showMessage(.removedFromWishlist, false)
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
                self.showMessage(.addedToWishlist, false)
                self.isFavorite = true
                self.updateFavoriteImage()
            }
        }
    }
    
    // MARK: - Private Methods
    private func updateProductInfo() {
        enableButtons()
        if let product = product {
            let price = product.variants.first?.price ?? "0.0"
            let currency = userDefaultManger.currency
#warning("rating for test ")
            rating = Double(product.id % 10 + 1) / 2
            updateStars()
            bindDataToVC(product.title, "\(exchange(price)) \(currency)", product.bodyHTML)
            updateDropdownOptions()
            selectedVariantID = product.variants.first?.id
            selectedVariantInventoryQuantity = product.variants.first?.inventoryQuantity
        }
    }
    
    private func updateSelectedVariantID() {
        if let variants = product?.variants {
            for variant in variants {
                if selectedSize == variant.option1 && selectedColor == variant.option2 {
                    selectedVariantID = variant.id
                    selectedVariantInventoryQuantity = variant.inventoryQuantity
                }
            }
        }
    }
    
    private func updateFavoriteState() {
        for item in wishlist ?? [] {
            if productID == item.productID {
                isFavorite = true
                break
            }
        }
        updateFavoriteImage()
    }
}
