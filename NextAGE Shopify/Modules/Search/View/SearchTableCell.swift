//
//  SearchTableCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/4/24.
//

import UIKit
import Kingfisher

class SearchTableCell: UITableViewCell {
    // MARK: -  IBOutlet
    @IBOutlet var backgroundViewCell: UIView!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var productLabel: UILabel!
    @IBOutlet var shadowView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var productImg: UIImageView!
    @IBOutlet var wishListButton: UIButton!
    
    // MARK: - Properties
    var product: Product?
    
    // MARK: - Closures
    var showLoginAlert: ()->() = {}
    
    // MARK: -  ViewLifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.gray : UIColor.white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Public Methods
    func updateUI(){
        wishListButton.setImage(UIImage(systemName: "heart"), for: .normal)
        shadowView.addCornerRadius(radius: 12)
        backgroundViewCell.addCornerRadius(radius: 12)
        backgroundViewCell.addBorderView()
        productImg.applyShadow()
    }
    
    func configure(with model: Product) {
        productImg.kf.setImage(with: URL(string: model.image.src),placeholder: UIImage(named: "brand1"))
        brandLabel.text = model.vendor
        priceLabel.text = exchange(model.variants.first?.price ?? "") + " " + UserDefaultsManager.shared.currency
        productLabel.text = model.title.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)
        
        let state = WishlistManager.shared.getFavoriteState(productID: model.id)
        wishListButton.setImage(UIImage(systemName: state ? "heart.fill" : "heart"), for: .normal)
    }
    
    // MARK: - IBActions
    @IBAction func wishListButtonClicked(_ sender: UIButton) {
        guard let product = product else {return}
        if UserDefaultsManager.shared.isLogin {
            WishlistManager.shared.addToOrRemoveFromWishlist(product: product) { state in
                self.wishListButton.setImage(UIImage(systemName: state ? "heart.fill" : "heart"), for: .normal)
                self.layoutIfNeeded()
            }
        } else {
            showLoginAlert()
        }
    }
}
