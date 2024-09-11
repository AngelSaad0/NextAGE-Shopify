//
//  AddAddressViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 04/09/2024.
//

import UIKit

class AddAddressViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet var cornerRadiusView:[UIView]!
    // MARK: - Properties
    let networkManager: NetworkManager
    let userDefaultsManager: UserDefaultManager
    let indicator = UIActivityIndicatorView(style: .large)
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultsManager = UserDefaultManager.shared
        super.init(coder: coder)
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    // MARK: - Private Methods
    private func updateUI() {
        title = "Add Address"
        for view in cornerRadiusView {
            view.addCornerRadius(radius: 12)
        }
        addAddressButton.addCornerRadius(radius: 12)
        setupIndicator()
    }
    private func setupIndicator() {
        indicator.center = view.center
        view.addSubview(indicator)
    }
    private func addAddress(completion: @escaping ()->()) {
        self.indicator.startAnimating()
        networkManager.postData(to: ShopifyAPI.addresses(id: userDefaultsManager.customerID).shopifyURLString(), responseType: EmptyResponse.self, parameters: [
            "address":
                [
                    "name": nameTextField.text ?? "",
                    "address1": addressTextField.text ?? "",
                    "city": cityTextField.text ?? "",
                    "phone": phoneTextField.text ?? "",
                    "default": defaultSwitch.isOn
                ]
        ]) { _ in
            displayMessage(massage: .defaultAddressUpdated, isError: false)
            self.indicator.stopAnimating()
            completion()
        }
    }
    // MARK: - IBActions
    @IBAction func addAddressButton(_ sender: Any) {
        addAddress {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

