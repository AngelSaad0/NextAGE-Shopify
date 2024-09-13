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

    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.addCornerRadius(radius: 10)
        imageBackground.addCornerRadius(radius: 12)
        imageBackground.addBorderView()
        //imageBackground.applyShadow()
    }
    func configure(with cell: ProductInfo) {
        productImage.kf.setImage(with: URL(string: cell.image.src),placeholder: UIImage(named: "brand1"))
        productTitle.text = cell.vendor
        productPrice.text = cell.variants[0].price
        productDetails.text = cell.title.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)

    }
    func configure(with cell: LineItem) {
        productImage.kf.setImage(with: URL(string: cell.properties[0].value),placeholder: UIImage(named: "brand1"))
        productTitle.text = "Quantity: \(cell.quantity)"
        productPrice.text = cell.price
        productDetails.text = cell.name?.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)
        currency.text = UserDefaultManager.shared.currency

    }
    func configureForWishlist(with cell: LineItem) {
        productImage.kf.setImage(with: URL(string: cell.properties[0].value),placeholder: UIImage(named: "brand1"))
        productTitle.text = cell.title?.split(separator: "|").first?.trimmingCharacters(in: .whitespaces)
        productPrice.text = cell.price
        productDetails.text = cell.title?.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)
        currency.text = UserDefaultManager.shared.currency

    }

    @IBAction func wishListButtonClicked(_ sender: UIButton) {
        sender.setImage(UIImage(systemName:sender.currentImage ==
                                UIImage(systemName: "heart") ? "heart.fill" : "heart" ), for: .normal)
    }
}
