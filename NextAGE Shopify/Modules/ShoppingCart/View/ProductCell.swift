//
//  ProductCell.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit
import Combine
import Kingfisher

class ProductCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet var backgroundViewCell: UIView!
    @IBOutlet weak var countPlus: UIButton!
    @IBOutlet weak var countMinus: UIButton!
    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    // MARK: - Properties
    var maxCount = 1
    var product: LineItem?
    var deleteButton: ()->() = {}
    var recalculateSum: ()->() = {}
    private let networkManager: NetworkManager
    private let userDefaultManager: UserDefaultsManager
    private var cancellables = Set<AnyCancellable>()
    private let incrementSubject = PassthroughSubject<Void, Never>()
    private let decrementSubject = PassthroughSubject<Void, Never>()
    private let debounceInterval = 0.5
    
    // MARK: - Required Initializer
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultManager = UserDefaultsManager.shared
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDebounce()
        updateCountingState()
        updateUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    // MARK: - Public Methods
    func configCell(with product: LineItem) {
        self.product = product
        productName.text = product.name
        productPrice.text = exchange(product.price) + " \(UserDefaultsManager.shared.currency)"
        productImage.kf.setImage(with: URL(string: product.properties[0].value))
        
        productCount.text = "\(product.quantity)"
        maxCount = max(1, (Int(product.properties[1].value) ?? 1) / 2)
        updateCountingState()
    }
    
    // MARK: - Private Methods
    private func updateUI(){
        backgroundViewCell.addBorderView()
        backgroundViewCell.addCornerRadius(radius: 12)
    }

    private func updateItemQuantity(newQuantity: Int) {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultManager.shoppingCartID).shopifyURLString(), responseType: DraftOrderWrapper.self) { result in
            let shoppingCart = result?.draftOrder.lineItems ?? []

            var shoppingCartLineItems: [[String: Any]] = []
            for item in shoppingCart {
                var properties : [[String: String]] = []
                for property in item.properties {
                    properties.append(["name":property.name, "value": property.value])
                }
                shoppingCartLineItems.append(["variant_id": item.variantID ?? 0, "quantity": ((item.variantID == self.product?.variantID) ? newQuantity : item.quantity), "properties": properties, "product_id": item.productID ?? 0])
            }
            
            self.networkManager.updateData(at: ShopifyAPI.draftOrder(id: self.userDefaultManager.shoppingCartID).shopifyURLString(), with: ["draft_order": ["line_items": shoppingCartLineItems]]) {
                self.recalculateSum()
            }
        }
    }
    
    private func updateCountingState() {
        if Int(productCount.text!)! > 1 {
            countMinus.isEnabled = true
        } else {
            countMinus.isEnabled = false
        }
        
        if Int(productCount.text!)! < maxCount {
            countPlus.isEnabled = true
        } else {
            countPlus.isEnabled = false
        }
    }
    
    private func setupDebounce() {
        incrementSubject
            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateItemQuantity(newQuantity: Int(self?.productCount.text ?? "") ?? 1)
            }
            .store(in: &cancellables)

        decrementSubject
            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateItemQuantity(newQuantity: Int(self?.productCount.text ?? "") ?? 1)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - IBActions
    @IBAction func countPlusButton(_ sender: Any) {
        productCount.text = String(Int(productCount.text!)! + 1)
        incrementSubject.send()
        updateCountingState()
    }
    
    @IBAction func countMinusButton(_ sender: Any) {
        productCount.text = String(Int(productCount.text!)! - 1)
        decrementSubject.send()
        updateCountingState()
    }
    
    @IBAction func removeItemButtonClicked(_ sender: Any) {
        self.deleteButton()
    }
}
