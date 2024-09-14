//
//  AddressViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 04/09/2024.
//

import UIKit

class AddressViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var selectPayment: UIButton!
    @IBOutlet var addNewAddressButton: UIButton!
    
    // MARK: - Properties
    var isSettings = false
    let viewModel: AddressViewModel
    let indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = AddressViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchAddresses()
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        title = "Address"
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        selectPayment.isEnabled = false
        if isSettings {
            selectPayment.setTitle("Set as default address", for: .normal)
        }
        setupIndicator()
        viewModel.fetchAddresses()
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
        viewModel.setSelectPaymentButton = { state in
            DispatchQueue.main.async { [weak self] in
                self?.selectPayment.isEnabled = state
            }
        }
        viewModel.bindResultToTableView = {
            DispatchQueue.main.async { [weak self] in
                self?.addressesTableView.reloadData()
            }
        }
        viewModel.showMessage = { message, isError in
            displayMessage(massage: message, isError: isError)
        }
        viewModel.displayEmptyMessage = { message in
            self.addressesTableView.displayEmptyMessage(message)
        }
        viewModel.removeEmptyMessage = {
            self.addressesTableView.removeEmptyMessage()
        }
    }
    
    // MARK: - IBActions
    @IBAction func addAddressButton(_ sender: Any) {
        pushViewController(vcIdentifier: "AddAddressViewController", withNav: navigationController)
    }
    
    @IBAction func selectPaymentOrSetDefaultAddressButton(_ sender: Any) {
        if isSettings {
            // set default address
            viewModel.setDefaultAddress()
        } else {
            // select payment
            viewModel.submitAddress {
                self.pushViewController(vcIdentifier: "PaymentViewController", withNav: self.navigationController)
            }
        }
    }
}

extension AddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in viewModel.addresses.indices {
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PaymentMethodCell {
                cell.deselect()
            }
        }
        if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodCell {
            cell.select()
        }
        if isSettings {
            viewModel.newDefaultAddressIndex = indexPath.row
            selectPayment.isEnabled = viewModel.newDefaultAddressIndex != viewModel.defaultAddressIndex
        } else {
            viewModel.selectedOrderAddress = indexPath.row
        }
    }
}

extension AddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentMethodCell
        cell.config(methodName: viewModel.addresses[indexPath.row].address1 ?? "", methodImageName: "gps")
        if viewModel.addresses[indexPath.row].addressDefault {
            viewModel.defaultAddressIndex = indexPath.row
            viewModel.selectedOrderAddress = indexPath.row
            cell.select()
            if !isSettings {
                selectPayment.isEnabled = true
            }
        } else {
            cell.deselect()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

