//
//  WishLIstTableViewCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/14/24.
//

import UIKit

class WishLIstTableViewCell: UITableViewCell {
    @IBOutlet var imageBackground: UIView!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var shadowView: UIView!

    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productDetails: UILabel!
    @IBOutlet var productPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.addCornerRadius(radius: 10)
        imageBackground.addCornerRadius(radius: 12)
        imageBackground.addBorderView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureForWishlist(with cell: LineItem) {
        productImage.kf.setImage(with: URL(string: cell.properties[0].value),placeholder: UIImage(named: "brand1"))
        productTitle.text = cell.title?.split(separator: "|").first?.trimmingCharacters(in: .whitespaces)
        productPrice.text = cell.price + " " + UserDefaultManager.shared.currency
        productDetails.text = cell.title?.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)

    }

}
