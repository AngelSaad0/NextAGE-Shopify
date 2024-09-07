//
//  OrdersTableViewCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/6/24.
//

import UIKit


class OrdersTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()

    }

    // MARK: - View Setup
    private func setupView() {
     cellBackgroundView.addCornerRadius(radius: 10)
        cellBackgroundView.addBorderView(color: Colors.C191919.rawValue, width: 1)
        cellBackgroundView.applyShadow()
    }
    // MARK: -  configure
    func configure(with order: Order) {
//        orderNumberLabel.text = "Order No \(order.id)"
//        totalPriceLabel.text = "\(order.totalPrice) \(order.currency)"
//        createdDateLabel.text = formatDate(order.createdAt)
    }



}
