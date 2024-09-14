//
//  Helper.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/4/24.
//

import SwiftMessages
import Foundation

 func formatDate(_ dateString: String) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Adjust according to your date format
       guard let date = dateFormatter.date(from: dateString) else { return dateString }
       dateFormatter.dateStyle = .medium
       dateFormatter.timeStyle = .none
       return dateFormatter.string(from: date)
   }

func exchange(_ price: String) -> String {
    return String(format: "%.2f", (Double(price) ?? 0.0) * UserDefaultsManager.shared.exchangeRate)
}

func exchange(_ price: Double) -> String {
    return String(format: "%.2f", price * UserDefaultsManager.shared.exchangeRate)
}

@MainActor
public func displayMessage(message: String,buttonTitle:String, isError: Bool, handler: (() -> Void)? = nil) {
    let view = MessageView.viewFromNib(layout: .cardView)

    if isError {
        view.configureTheme(.error)
        view.alpha = 0.9
    } else {
        view.configureTheme(.success)
        view.alpha = 0.8
    }

    view.titleLabel?.isHidden = true
    view.bodyLabel?.text = message
    view.bodyLabel?.textColor = UIColor.white

    view.button?.isHidden = false
    view.button?.setTitle(buttonTitle, for: .normal)
    view.button?.setTitleColor(.white, for: .normal)
    view.button?.backgroundColor = .red
    view.button?.layer.cornerRadius = 10

    view.buttonTapHandler = { _ in
        SwiftMessages.hide()
        handler?()
    }

    var config = SwiftMessages.Config()
    config.presentationStyle = .bottom
    config.shouldAutorotate = true
    SwiftMessages.show(config: config, view: view)
}


@MainActor public func displayMessage(massage:ValidMessage , isError: Bool) {
    let view = MessageView.viewFromNib(layout: .cardView)
    if isError == true {
        view.configureTheme(.error)
        view.alpha = 0.5
    } else {
        view.configureTheme(.success)
        view.alpha = 0.8
    }
    view.titleLabel?.isHidden = true
    view.bodyLabel?.text = massage.rawValue
    view.titleLabel?.textColor = UIColor.white
    view.bodyLabel?.textColor = UIColor.white
    view.button?.isHidden = true
    view.alpha = 0.9
    var config = SwiftMessages.Config()
    config.presentationStyle = .bottom
    config.shouldAutorotate = true
    SwiftMessages.show(config: config, view: view)
}

func isValidEmail(_ email: String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: email)
}
func isValidMobile(_ mobileNumber: String) -> Bool {
    let mobileNumberRegex = "^\\d{11}$"
    let mobileNumberPredicate = NSPredicate(format: "SELF MATCHES %@", mobileNumberRegex)
    return mobileNumberPredicate.evaluate(with: mobileNumber)
}
func isValidName(_ name: String) -> Bool {
    let nameRegex = "^[a-zA-Z]{4,}$"
    let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
    return namePredicate.evaluate(with: name)
}
func isValidMobileOrEmail(_ input: String) -> Bool {
    let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let mobileNumberRegex = "^\\d{11}$"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    let mobileNumberPredicate = NSPredicate(format: "SELF MATCHES %@", mobileNumberRegex)
    return emailPredicate.evaluate(with: input) || mobileNumberPredicate.evaluate(with: input)
}
//func isValidPassword(_ password: String) -> Bool {
//    let passwordRegex = "^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$"
//    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//    return passwordPredicate.evaluate(with: password)
//}
func isValidPassword(_ password: String) -> Bool {

    return password.count >= 6
}


@MainActor
public func displayMessage(
    message: String,
    isError: Bool,
    stopHandler: (() -> Void)? = nil,
    cancelHandler: (() -> Void)? = nil
) {
    let view = MessageView.viewFromNib(layout: .cardView)

    if isError {
        view.configureTheme(.error)
        view.alpha = 0.9
    } else {
        view.configureTheme(.success)
        view.alpha = 0.8
    }

    view.titleLabel?.isHidden = true
    view.bodyLabel?.text = message
    view.bodyLabel?.textColor = UIColor.white

    // Create and configure "Stop" button
    let stopButton = UIButton(type: .system)
    stopButton.setTitle("Stop", for: .normal)
    stopButton.setTitleColor(.white, for: .normal)
    stopButton.backgroundColor = .red
    stopButton.layer.cornerRadius = 10
    stopButton.translatesAutoresizingMaskIntoConstraints = false
    stopButton.addAction(UIAction(handler: { _ in
        SwiftMessages.hide()
        stopHandler?() // Executes the stop handler
    }), for: .touchUpInside)
    view.addSubview(stopButton)

    // Create and configure "Cancel" button
    let cancelButton = UIButton(type: .system)
    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.setTitleColor(.white, for: .normal)
    cancelButton.backgroundColor = .gray
    cancelButton.layer.cornerRadius = 10
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.addAction(UIAction(handler: { _ in
        SwiftMessages.hide()
        cancelHandler?() // Executes the cancel handler
    }), for: .touchUpInside)
    view.addSubview(cancelButton)

    // Layout the buttons
    NSLayoutConstraint.activate([
        // Stop Button Constraints
        stopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        stopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        stopButton.widthAnchor.constraint(equalToConstant: 80),
        stopButton.heightAnchor.constraint(equalToConstant: 44),

        // Cancel Button Constraints
        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        cancelButton.widthAnchor.constraint(equalToConstant: 80),
        cancelButton.heightAnchor.constraint(equalToConstant: 44),

        // Align buttons horizontally
        stopButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -16)
    ])

    // SwiftMessages configuration
    var config = SwiftMessages.Config()
    config.presentationStyle = .bottom
    config.shouldAutorotate = true
    SwiftMessages.show(config: config, view: view)
}


