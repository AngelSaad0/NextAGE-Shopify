//
//  CustomButton.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/11/24.
//

import UIKit

class CustomBlueButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        self.backgroundColor =  UIColor(named:         Colors.C535353.rawValue)
        self.setTitleColor(.white, for: .normal)
        self.addRoundedRadius(radius: 12)
        self.layer.masksToBounds = true
    }


}
