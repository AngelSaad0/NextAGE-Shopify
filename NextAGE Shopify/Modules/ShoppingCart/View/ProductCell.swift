//
//  ProductCell.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

class ProductCell: UITableViewCell {
    let maxCount = 5

    @IBOutlet var backgroundViewCell: UIView!
    @IBOutlet weak var countPlus: UIButton!
    @IBOutlet weak var countMinus: UIButton!
    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    //@IBOutlet weak var productInfo: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        countPlus.layer.cornerRadius = countPlus.frame.width/2
//        countPlus.layer.borderWidth = 1.0
        
//        countMinus.layer.cornerRadius = countMinus.frame.width/2
//        countMinus.layer.borderWidth = 1.0
        
        updateCountingState()
        updateUI()
    }
    func updateUI(){
        backgroundViewCell.addBorderView()
        backgroundViewCell.addCornerRadius(radius: 12)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    @IBAction func countPlusButton(_ sender: Any) {
        productCount.text = String(Int(productCount.text!)! + 1)
        updateCountingState()
    }
    
    @IBAction func countMinusButton(_ sender: Any) {
        productCount.text = String(Int(productCount.text!)! - 1)
        updateCountingState()
    }
    
    func configCell(with product: DummyProduct) {
        productName.text = product.productName
       // productInfo.text = product.productInfo
        productPrice.text = product.productPrice + " EGP"
        productImage.image = UIImage(named: product.productImage)
    }
    
    func updateCountingState() {
        if Int(productCount.text!)! > 0 {
            countMinus.isEnabled = true
//            countMinus.layer.borderColor = UIColor.black.cgColor
        } else {
            countMinus.isEnabled = false
//            countMinus.layer.borderColor = UIColor.gray.cgColor
        }
        
        if Int(productCount.text!)! < maxCount {
            countPlus.isEnabled = true
//            countPlus.layer.borderColor = UIColor.black.cgColor
        } else {
            countPlus.isEnabled = false
//            countPlus.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
