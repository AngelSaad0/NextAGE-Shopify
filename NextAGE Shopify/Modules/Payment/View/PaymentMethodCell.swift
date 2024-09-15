//
//  PaymentMethodCell.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import UIKit

class PaymentMethodCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var paymentMethodSelected: UIImageView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var paymentMethodImage: UIImageView!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    // MARK: - Public Methods
    func config(methodName: String, methodImageName: String) {
        paymentMethodLabel.text = methodName
        paymentMethodImage.image = UIImage(named: methodImageName)
    }
    
    func select() {
        paymentMethodSelected.isHidden = false
    }
    
    func deselect() {
        paymentMethodSelected.isHidden = true
    }
}
