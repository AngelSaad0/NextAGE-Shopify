//
//  OrderTableViewCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/7/24.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.systemBackground : UIColor.systemBackground
        }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        cellBackgroundView.addCornerRadius(radius: 12)
        cellBackgroundView.addBorderView()
    }
    
    // MARK: - Public Methods
    func configure(with order: Order) {
        orderNumberLabel.text = "#\(order.orderNumber)"
        totalPriceLabel.text = order.totalPrice + " " + order.currency
        createdDateLabel.text = formatDate(order.createdAt)
    }
}
