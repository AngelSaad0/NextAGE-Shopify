//
//  BrandsCollectionViewCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/2/24.
//

import UIKit

class BrandsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var brandBackground: UIView!
    @IBOutlet weak var brandImg: UIImageView!
    static func nib()->UINib{
        return UINib(nibName: "BrandsCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        updatUI()
    }
    func updatUI(){
        brandBackground.layer.borderColor = UIColor.black.cgColor
        backgroundView?.addBorderView(color:Colors.CF8F8F8.rawValue, width: 2)
        brandBackground.addCornerRadius(radius:10)
        brandImg.addCornerRadius(radius: 10)

    }
    func configure(with model: adsModel) {
        brandImg.image = UIImage(named: model.image)

    }

}
