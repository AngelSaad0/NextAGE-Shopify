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

}
