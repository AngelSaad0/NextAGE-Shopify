//
//  AdsCollectionCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/2/24.
//

import UIKit

class AdsCollectionCell: UICollectionViewCell {

    @IBOutlet var addsImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updatUI()
    }

    func updatUI(){
        addsImg.addCornerRadius(radius: 10)
    }
    func configure(with model: adsModel) {
        addsImg.image = UIImage(named: model.image)

    }

}
