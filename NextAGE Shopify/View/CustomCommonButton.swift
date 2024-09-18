//
//  CustomCommanButton.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/11/24.
//

import UIKit

class CustomCommonButton: UIButton {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Private Methods
    private func setupButton() {
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
}
