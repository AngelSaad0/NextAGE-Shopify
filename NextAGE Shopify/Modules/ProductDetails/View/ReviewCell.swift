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
    @IBOutlet weak var userReviewLabel: UILabel!

    @IBOutlet var dateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        cellBackgroundView.addCornerRadius(radius: 12)
        cellBackgroundView.addBorderView()
    }
    func configure(with cell:DumyReview) {
        userImageView.image = UIImage(named:cell.userImage)
        userNameLabel.text = cell.userName
        reviewRatingLabel.text = cell.rating
        dateLabel.text = cell.date
        userReviewLabel.text = cell.review



    }
}
