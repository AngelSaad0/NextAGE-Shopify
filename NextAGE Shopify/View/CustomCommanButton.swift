//
//  CustomCommanButton.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/11/24.
//

import UIKit

class CustomCommanButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }


}
