//
//  CategoriesCollectionCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import UIKit

class CategoriesCollectionCell: UICollectionViewCell {

    @IBOutlet var imageBackground: UIView!
    @IBOutlet var shadowView: UIView!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productDetails: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var currency: UILabel!
    @IBOutlet var wishListButton: UIButton!
    
    var product: Product?

    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.addCornerRadius(radius: 10)
        imageBackground.addCornerRadius(radius: 12)
        imageBackground.addBorderView()
        //imageBackground.applyShadow()
    }
    func configure(with cell: Product) {
        productImage.kf.setImage(with: URL(string: cell.image.src),placeholder: UIImage(named: "brand1"))
        productTitle.text = cell.vendor
        productPrice.text = exchange(cell.variants[0].price)
        productDetails.text = cell.title.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)
        currency.text = UserDefaultsManager.shared.currency
        
        let state = WishlistManager.shared.getFavoriteState(productID: cell.id)
        wishListButton.setImage(UIImage(systemName: state ? "heart.fill" : "heart"), for: .normal)
    }
    func configure(with cell: LineItem) {
        productImage.kf.setImage(with: URL(string: cell.properties[0].value),placeholder: UIImage(named: "brand1"))
        productTitle.text = "Quantity: \(cell.quantity)"
        productPrice.text = exchange(cell.price)
        productDetails.text = cell.name?.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)
        currency.text = UserDefaultsManager.shared.currency

    }
    func configureForWishlist(with cell: LineItem) {
        productImage.kf.setImage(with: URL(string: cell.properties[0].value),placeholder: UIImage(named: "brand1"))
        productTitle.text = cell.title?.split(separator: "|").first?.trimmingCharacters(in: .whitespaces)
        productPrice.text = exchange(cell.price)
        productDetails.text = cell.title?.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)
        currency.text = UserDefaultsManager.shared.currency

    }

    @IBAction func wishListButtonClicked(_ sender: UIButton) {
        guard let product = product else {return}
        WishlistManager.shared.addToWishlist(product: product) { state in
            self.wishListButton.setImage(UIImage(systemName: state ? "heart.fill" : "heart"), for: .normal)
            self.layoutIfNeeded()
        }
    }
}
