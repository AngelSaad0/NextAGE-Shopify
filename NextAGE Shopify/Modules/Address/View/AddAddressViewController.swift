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
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet var cornerRadiusView:[UIView]!
    
    // MARK: - Properties
    let viewModel: AddAddressViewModel
    let indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = AddAddressViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.isEditing {
            title = "Edit Address"
            restoreFields()
            addAddressButton.setTitle("Edit Address", for: .normal)
            defaultSwitch.isEnabled = !(viewModel.address?.addressDefault ?? false)
        }
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        title = "Add Address"
        for view in cornerRadiusView {
            view.addCornerRadius(radius: 12)
        }
        setupIndicator()
    }
    
    private func setupIndicator() {
        indicator.center = view.center
        view.addSubview(indicator)
    }
    
    private func setupViewModel() {
        viewModel.setIndicator = { state in
            DispatchQueue.main.async { [weak self] in
                if state {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }
        }
        viewModel.showSuccessMessage = {
            displayMessage(massage: .newAddressAdded, isError: false)
        }
        viewModel.showSuccessMessage = {
            displayMessage(massage: .addressEdited, isError: false)
        }
    }
    
    private func restoreFields() {
        guard let address = viewModel.address else {
            displayMessage(massage: .addressesFetchingFailed, isError: true)
            return
        }
        nameTextField.text = address.name
        addressTextField.text = address.address1
        cityTextField.text = address.city
        countryTextField.text = address.country
        phoneTextField.text = address.phone
        defaultSwitch.isOn = address.addressDefault
    }
    
    private func validateRegisterFields() -> Bool {
        if nameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .nameEmpty, isError: true)
            return false
        }
        if !isValidNameWithSpaces(nameTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            displayMessage(massage: .nameVaild, isError: true)
            return false
        }
        if addressTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .addressEmpty, isError: true)
            return false
        }
        if !isValidAddress(addressTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            displayMessage(massage: .addressVaild, isError: true)
            return false
        }
        if cityTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .cityEmpty, isError: true)
            return false
        }
        if !isValidAddress(cityTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            displayMessage(massage: .cityVaild, isError: true)
            return false
        }
        if countryTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .countryEmpty, isError: true)
            return false
        }
        if !isValidAddress(countryTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            displayMessage(massage: .cityVaild, isError: true)
            return false
        }
        if phoneTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .mobileEmpty, isError: true)
            return false
        }
        if !isValidMobile(phoneTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
            displayMessage(massage: .mobileVaild, isError: true)
            return false
        }
        return true
    }
    
    // MARK: - IBActions
    @IBAction func addAddressButton(_ sender: Any) {
        if validateRegisterFields() {
            if viewModel.isEditing {
                viewModel.editAddress(name: nameTextField.text, address: addressTextField.text, city: cityTextField.text,country: countryTextField.text, phone: phoneTextField.text, isDefault: defaultSwitch.isOn) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                viewModel.addAddress(name: nameTextField.text, address: addressTextField.text, city: cityTextField.text,country: countryTextField.text, phone: phoneTextField.text, isDefault: defaultSwitch.isOn) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

