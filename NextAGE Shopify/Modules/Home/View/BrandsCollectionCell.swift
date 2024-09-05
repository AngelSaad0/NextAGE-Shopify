//
//  BrandsCollectionViewCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/2/24.
//

import UIKit
import Kingfisher

class BrandsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var brandBackground: UIView!
    @IBOutlet weak var brandImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updatUI()
    }
    
    func updatUI(){
        brandBackground.addBorderView(color: Colors.C000000.rawValue, width: 2)
        brandBackground.addRoundedRadius(radius: 12)
        brandImg.addCornerRadius(radius: 8)
        
        brandBackground.clipsToBounds = true
    }
    
    func configure(with cell: SmartCollection) {
        brandImg.kf.setImage(with: URL(string: cell.image.src),placeholder: UIImage(named: "brand1"))
        
    }
    
}
