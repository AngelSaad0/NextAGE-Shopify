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
    @IBOutlet weak var reviewOrderOrSetDefaultAddressButton: UIButton!
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
        viewModel.checkInternetConnection()
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        title = "Address"
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        reviewOrderOrSetDefaultAddressButton.isEnabled = false
        if isSettings {
            reviewOrderOrSetDefaultAddressButton.setTitle("Set as default address", for: .normal)
        }
        setupIndicator()
        viewModel.checkInternetConnection()
    }
    
    private func setupIndicator() {
        indicator.center = view.center
        view.addSubview(indicator)
    }
    
    private func setupViewModel() {
        viewModel.showNoInternetAlert = {
            self.showNoInternetAlert()
        }
        viewModel.setIndicator = { state in
            DispatchQueue.main.async { [weak self] in
                if state {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }
        }
        viewModel.setReviewOrderOrDefaultAddressButton = { state in
            DispatchQueue.main.async { [weak self] in
                self?.reviewOrderOrSetDefaultAddressButton.isEnabled = state
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
    
    @IBAction func reviewOrderOrSetDefaultAddressButtonClicked(_ sender: Any) {
        if isSettings {
            // set default address
            viewModel.setDefaultAddress()
        } else {
            // review order
            viewModel.submitAddress {
                self.pushViewController(vcIdentifier: "DiscountViewController", withNav: self.navigationController)
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
            reviewOrderOrSetDefaultAddressButton.isEnabled = viewModel.newDefaultAddressIndex != viewModel.defaultAddressIndex
        } else {
            viewModel.selectedOrderAddress = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
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
                reviewOrderOrSetDefaultAddressButton.isEnabled = true
            }
        } else {
            cell.deselect()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                    if self.viewModel.addresses[indexPath.row].addressDefault {
                        self.showAlert(title: "Default address", message: "You can't delete your default address, try setting another address to be the default in order to delete this one")
                    } else {
                        self.showAlert(title: "Delete address?", message: "Are you sure you want to delete this address?", okTitle: "Yes", cancelTitle: "No", okStyle: .destructive, cancelStyle: .cancel) { _ in
                            self.viewModel.deleteAddress(at: indexPath.row)
                        } cancelHandler: {_ in}
                    }
                    completionHandler(true)
                }
                
                let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
                    vc.viewModel.isEditing = true
                    vc.viewModel.address = self.viewModel.addresses[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
                    completionHandler(true)
                }
                editAction.backgroundColor = .gray
                let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
                configuration.performsFirstActionWithFullSwipe = true
                return configuration
    }
}

