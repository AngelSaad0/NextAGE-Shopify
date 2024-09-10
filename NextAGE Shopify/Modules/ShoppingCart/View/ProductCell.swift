//
//  ProductCell.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    @IBOutlet var backgroundViewCell: UIView!
    @IBOutlet weak var countPlus: UIButton!
    @IBOutlet weak var countMinus: UIButton!
    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var maxCount = 1
    var product: LineItem?
    var deleteButton: ()->() = {}
    var recalculateSum: ()->() = {}
    private let networkManager: NetworkManager
    private let userDefaultManager: UserDefaultManager
    
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultManager = UserDefaultManager.shared
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateCountingState()
        updateUI()
    }
    
    private func updateUI(){
        backgroundViewCell.addBorderView()
        backgroundViewCell.addCornerRadius(radius: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    @IBAction func countPlusButton(_ sender: Any) {
        productCount.text = String(Int(productCount.text!)! + 1)
#warning("make delegate to update subtotal form shoppingCartVC and reload table")
        updateItemQuantity(newQuantity: Int(productCount.text ?? "") ?? 1)
        updateCountingState()
    }
    
    @IBAction func countMinusButton(_ sender: Any) {
        productCount.text = String(Int(productCount.text!)! - 1)
        updateItemQuantity(newQuantity: Int(productCount.text ?? "") ?? 1)
        updateCountingState()
    }
    
    func configCell(with product: LineItem) {
        self.product = product
        productName.text = product.name
        productPrice.text = product.price + " \(UserDefaultManager.shared.currency)"
        productImage.kf.setImage(with: URL(string: product.properties[0].value))
        
        productCount.text = "\(product.quantity)"
        maxCount = Int(product.properties[1].value) ?? 1
        updateCountingState()
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
    
    @IBAction func removeItemButtonClicked(_ sender: Any) {
        self.deleteButton()
    }
}
