//
//  AddressViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 04/09/2024.
//

import UIKit

class AddressViewController: UIViewController {

    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var selectPayment: UIButton!
    @IBOutlet var addNewAddressButton: UIButton!
    
    var isSettings = false
    var addresses: [Address] = []
    var defaultAddressIndex: Int?
    var newDefaultAddressIndex: Int?
    var selectedOrderAddress: Int?
    let networkManager: NetworkManager
    let userDefaultsManager: UserDefaultManager
    let indicator = UIActivityIndicatorView(style: .large)
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultsManager = UserDefaultManager.shared
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchAddresses()
    }
    private func updateUI() {
        title = "Address"
        addNewAddressButton.addCornerRadius(radius: 12)
        selectPayment.addCornerRadius(radius: 12)
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        selectPayment.isEnabled = false
        if isSettings {
            selectPayment.setTitle("Set as default address", for: .normal)
        }
        setupIndicator()
        fetchAddresses()
    }
    private func setupIndicator() {
        indicator.center = view.center
        view.addSubview(indicator)
    }
    
    private func fetchAddresses() {
        indicator.startAnimating()
        networkManager.fetchData(from: ShopifyAPI.addresses(id: userDefaultsManager.customerID).shopifyURLString(), responseType: Addresses.self) { result in
            self.indicator.stopAnimating()
            guard let addresses = result?.addresses else {
                displayMessage(massage: .addressesFetchingFailed, isError: true)
                return
            }
            self.addresses = addresses
            self.addressesTableView.reloadData()
        }
    }
    
    private func submitAddress(completion: @escaping ()->()) {
        var addressParameters: [String: Any] = [:]
        if addresses.indices.contains(selectedOrderAddress ?? -1) {
            addressParameters = [
                "name": addresses[selectedOrderAddress!].name,
                "address1": addresses[selectedOrderAddress!].address1,
                "city": addresses[selectedOrderAddress!].city,
                "phone": addresses[selectedOrderAddress!].phone,
            ]
        }
        networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultsManager.shoppingCartID).shopifyURLString(), with: ["draft_order": ["shipping_address": addressParameters]]) {
            completion()
        }
    }

    @IBAction func addAddressButton(_ sender: Any) {
        pushViewController(vcIdentifier: "AddAddressViewController", withNav: navigationController)
    }
    @IBAction func selectPaymentOrSetDefaultAddressButton(_ sender: Any) {
        if isSettings {
            // set default address
            guard let selectedNewAddressIndex = newDefaultAddressIndex else {
                displayMessage(massage: .newSelectedAddressFailed, isError: true)
                return
            }
            let addressID = addresses[selectedNewAddressIndex].id
            networkManager.updateData(at: ShopifyAPI.defaultAddress(addressID: addressID, customerID: userDefaultsManager.customerID).shopifyURLString(), with: [:]) {
                displayMessage(massage: .defaultAddressUpdated, isError: false)
                self.selectPayment.isEnabled = false
                self.fetchAddresses()
            }
        } else {
            // select payment
            submitAddress {
                self.pushViewController(vcIdentifier: "PaymentViewController", withNav: self.navigationController)
            }
        }
    }
}

extension AddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in addresses.indices {
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PaymentMethodCell {
                cell.deselect()
            }
        }
        if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodCell {
            cell.select()
        }
        if isSettings {
            newDefaultAddressIndex = indexPath.row
            selectPayment.isEnabled = newDefaultAddressIndex != defaultAddressIndex
        } else {
            selectedOrderAddress = indexPath.row
        }
    }
}

extension AddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentMethodCell
        cell.config(methodName: addresses[indexPath.row].address1, methodImageName: "gps")
        if addresses[indexPath.row].addressDefault {
            defaultAddressIndex = indexPath.row
            selectedOrderAddress = indexPath.row
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

