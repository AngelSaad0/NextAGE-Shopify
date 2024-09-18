//
//  ReviewCell.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import UIKit

class ReviewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var cellBackgroundView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var reviewRatingLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userReviewLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var shadowBackground: UIView!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    // MARK: - Private Methods
    func updateUI() {
        [cellBackgroundView,shadowBackground].forEach{$0.addCornerRadius(radius: 12)}
        cellBackgroundView.addBorderView()
    }
    
    // MARK: - Public Methods
    func configure(with cell: DumyReview) {
        userImageView.image = UIImage(named: cell.userImage)
        userNameLabel.text = cell.userName
        reviewRatingLabel.text = cell.rating
        dateLabel.text = cell.date
        userReviewLabel.text = cell.review
    }
}
