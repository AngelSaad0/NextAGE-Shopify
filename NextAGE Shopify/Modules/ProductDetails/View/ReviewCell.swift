//
//  ReviewCell.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var reviewRatingLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UIStackView!
    @IBOutlet weak var userReviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        #warning("user image changed")
        userImageView.image = UIImage(named: "1person")
        cellBackgroundView.addCornerRadius(radius: 12)
        cellBackgroundView.addBorderView()
    }
}
