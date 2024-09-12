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
    
    // MARK: - Private Methods
    private func updateUI() {
        title = "Add Address"
        for view in cornerRadiusView {
            view.addCornerRadius(radius: 12)
        }
//        addAddressButton.addCornerRadius(radius: 12)
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
    }
    
    // MARK: - IBActions
    @IBAction func addAddressButton(_ sender: Any) {
        viewModel.addAddress(name: nameTextField.text, address: addressTextField.text, city: cityTextField.text, phone: phoneTextField.text, isDefault: defaultSwitch.isOn) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

