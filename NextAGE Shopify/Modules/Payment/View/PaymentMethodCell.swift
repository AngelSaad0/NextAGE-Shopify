//
//  PaymentMethodCell.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

    @IBOutlet weak var paymentMethodSelected: UIImageView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var paymentMethodImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
//        self.contentView.backgroundColor = UIColor.white
    }
    
    func config(methodName: String, methodImageName: String) {
        paymentMethodLabel.text = methodName
        paymentMethodImage.image = UIImage(systemName: methodImageName)
    }
    
    func select() {
        paymentMethodSelected.isHidden = false
    }
    
    func deselect() {
        paymentMethodSelected.isHidden = true
    }

}
