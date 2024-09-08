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

    @IBOutlet var productImg: UIImageView!
    @IBOutlet var brandTitle: UILabel!
    @IBOutlet var productTitleD: UILabel!

    // MARK: -  ViewLifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.gray : UIColor.white
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }


    // MARK: -  methods

    func updateUI(){
        productImg.addCornerRadius(radius: 8)

    }
    func configure(with model: Product) {
        productImg.kf.setImage(with: URL(string: model.image.src),placeholder: UIImage(named: "brand1"))
        brandTitle.text = model.vendor
        productTitleD.text = model.title.split(separator: "|").dropFirst().first?.trimmingCharacters(in: .whitespaces)

    }

}
