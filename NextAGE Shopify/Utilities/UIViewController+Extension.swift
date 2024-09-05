//
//  UIViewController+Extension.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/4/24.
//

import UIKit
extension UIViewController {
    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet", message: "Please check your internet connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(
        title: String,
        message: String,
        okTitle: String = "OK",
        cancelTitle: String = "Cancel",
        okStyle: UIAlertAction.Style = .default,
        cancelStyle: UIAlertAction.Style = .cancel,
        okHandler: ((UIAlertAction) -> Void)? = nil,
        cancelHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: okTitle, style: okStyle, handler: okHandler))
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: cancelStyle, handler: cancelHandler))
        
        present(alert, animated: true, completion: nil)
    }
}
