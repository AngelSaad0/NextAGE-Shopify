//
//  BrandsCollectionViewCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/2/24.
//

import UIKit
import Kingfisher

class BrandCollectionCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var brandBackground: UIView!
    @IBOutlet weak var brandImg: UIImageView!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updatUI()
    }
    
    // MARK: - Private Methods
    private func updatUI(){
        brandBackground.addBorderView()
        [brandBackground,brandImg].forEach{$0?.addCornerRadius(radius: 12)}
    }
    
    // MARK: - Public Methods
    func configure(with cell: SmartCollection) {
        brandImg.kf.setImage(with: URL(string: cell.image.src),placeholder: UIImage(named: "brand1"))
        
    }
    
}
