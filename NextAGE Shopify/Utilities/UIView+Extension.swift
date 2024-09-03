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
    func animateImageView(imageView: UIImageView) {
        UIView.animate(withDuration: 0.6,animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)})
        UIView.animate(withDuration: 0.6, animations:{
            imageView.transform = CGAffineTransform.identity
        })
    }
    func addBorderView(color:Colors.RawValue,width:CGFloat){
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


    
}
