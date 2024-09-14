//
//  WishLIstTableViewCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/14/24.
//

import UIKit

class WishlistTableViewCell: UITableViewCell {
    // MARK: - IBOutlete
    @IBOutlet var imageBackground: UIView!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var shadowView: UIView!
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productDetails: UILabel!
    @IBOutlet var productPrice: UILabel!

    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.addCornerRadius(radius: 10)
        imageBackground.addCornerRadius(radius: 12)
        imageBackground.addBorderView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    // MARK: - Public Methods
    func configureForWishlist(with cell: LineItem) {
        productImage.kf.setImage(with: URL(string: cell.properties[0].value),placeholder: UIImage(named: "brand1"))
        productTitle.text = cell.title?.split(separator: "|").first?.trimmingCharacters(in: .whitespaces)
        productPrice.text = cell.price + " " + UserDefaultsManager.shared.currency
        productDetails.text = cell.title?.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)
    }
}
