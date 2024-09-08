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
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // productImage.addCornerRadius(radius: 10)
        imageBackground.addCornerRadius(radius: 12)
        imageBackground.addBorderView()
//        imageBackground.applyShadow()
    }
    func configure(with cell: ProductInfo) {
        productImage.kf.setImage(with: URL(string: cell.image.src),placeholder: UIImage(named: "brand1"))
        productTitle.text = cell.vendor
        productPrice.text = cell.variants[0].price
        productDetails.text = cell.title.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)

    }
    func configure(with cell: LineItem) {
#warning("productImage.image ")
//        productImage.kf.setImage(with: URL(string: cell.name ?? ""),placeholder: UIImage(named: "brand1"))
      //  productImage.image = UIImage(named: "brand1")
        productTitle.text = cell.name
        productPrice.text = cell.price
#warning("cell.productID?.descriptione")
        productDetails.text = cell.productID?.description
        currency.text = UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD"

    }

}
