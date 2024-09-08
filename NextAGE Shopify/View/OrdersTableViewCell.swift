//
//  OrderTableViewCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/7/24.
//

import UIKit


class OrdersTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()

    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.systemBackground : UIColor.systemBackground
        }
    }

    // MARK: - View Setup
    private func setupView() {
        cellBackgroundView.addCornerRadius(radius: 12)
        cellBackgroundView.addBorderView()
//        cellBackgroundView.applyShadow()
    }
// MARK: -  configure
    func configure(with order: Order) {
           orderNumberLabel.text = "Order No \(order.id)"
           totalPriceLabel.text = "\(order.totalPrice) \(order.currency)"
           createdDateLabel.text = formatDate(order.createdAt)
       }
    func configure(with lineItem: LineItem) {
           orderNumberLabel.text = "Order No \(lineItem.id)"
           totalPriceLabel.text = "\(lineItem.price) \(lineItem.title ?? "")"
        #warning("LineItem havant data what is correct pass all order array ?")
       // createdDateLabel.text = formatDate(LineItem.createdAt)

       }

}
