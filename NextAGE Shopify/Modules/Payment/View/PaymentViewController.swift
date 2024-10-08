//
//  PaymentViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var paymentMethodsTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    // MARK: - Properties
    let viewModel: PaymentViewModel
    
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = PaymentViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
        viewModel.fetchShoppingCart(shoppingCartID: viewModel.userDefaultsManager.shoppingCartID)
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        title = "Payment method"
        purchaseButton.isEnabled = false
        paymentMethodsTableView.delegate = self
        paymentMethodsTableView.dataSource = self
    }
    
    private func setupViewModel() {
        viewModel.presentPaymentRequest = { paymentRequest in
            DispatchQueue.main.async { [weak self] in
                if let paymentController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                    paymentController.delegate = self
                    self?.present(paymentController, animated: true)
                }
            }
        }
        viewModel.pushConfirmationViewController = {
            self.pushViewController(vcIdentifier: "ConfirmationViewController", withNav: self.navigationController)
        }
        viewModel.showFailOrderMessage = {
            displayMessage(massage: .placingOrderFailed, isError: true)
        }
        viewModel.bindTotalAmount = { amount in
            self.totalAmountLabel.text = amount
        }
    }
    
    // MARK: - IBActions
    @IBAction func purchaseButtonClicked(_ sender: Any) {
        switch viewModel.selectedPaymentMethod {
        case 0:
            viewModel.applePay()
        default:
            viewModel.purchaseOrder()
        }
    }
}

extension PaymentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in viewModel.paymentMethods.indices {
            (tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! PaymentMethodCell).deselect()
        }
        (tableView.cellForRow(at: indexPath) as! PaymentMethodCell).select()
        viewModel.selectedPaymentMethod = indexPath.row
        purchaseButton.isEnabled = true
    }
}

extension PaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentMethodCell
        cell.config(methodName: viewModel.paymentMethods[indexPath.row].0, methodImageName: viewModel.paymentMethods[indexPath.row].1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        viewModel.purchaseOrder()
    }
}

