//
//  UIView+Extension.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/1/24.
//

import UIKit
extension UIView {
    func addCornerRadius(radius:CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        
    }
    func addRoundedRadius(radius:CGFloat){
        self.layer.cornerRadius = self.frame.height/radius
        self.clipsToBounds = true
        
    }
    func animateImageView(imageView: UIImageView) {
        UIView.animate(withDuration: 0.6,animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)})
        UIView.animate(withDuration: 0.6, animations:{
            imageView.transform = CGAffineTransform.identity
        })
    }
    func addBorderView(color:Colors.RawValue =  Colors.C707070.rawValue,width:CGFloat = 0.8) {
        self.layer.borderColor = UIColor(named:color)?.cgColor
        self.layer.borderWidth = width
    }
    func applyShadow(color: UIColor = .black,
                     opacity: Float = 0.3,
                     offset: CGSize = CGSize(width: 0, height: 2),
                     radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    func displayEmptyMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Avenir", size: 18)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    func removeEmptyMessage() {
        for subview in self.subviews {
            if let label = subview as? UILabel, label.textColor == .black {
                label.removeFromSuperview()
            }
        }
    }
}

