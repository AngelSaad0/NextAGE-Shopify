//
//  CategoriesCollectionCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import UIKit

class CategoriesCollectionCell: UICollectionViewCell {

    @IBOutlet var imageBackground: UIView!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productDetails: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var currency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageBackground.addCornerRadius(radius: 10)
        productImage.addCornerRadius(radius: 10)
        imageBackground.addBorderView(color: Colors.C191919.rawValue, width: 1)
        imageBackground.applyShadow()
    }
    func configure(with model: adsModel) {
        productImage.image = UIImage(named: model.image)

    }


}
