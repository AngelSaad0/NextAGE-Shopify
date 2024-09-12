//
//  OrderViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/7/24.
//

import UIKit

class AllOrdersViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var orderTableView: UITableView!
    
    // MARK: - Properties
    let viewModel: AllOrdersViewModel
    private let indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = AllOrdersViewModel()
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
        title = "All Orders"
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
        setupIndicators()
        viewModel.updateUserOrders()
    }
    
    private func setupIndicators() {
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
        viewModel.showMessage = { message in
            self.orderTableView.displayEmptyMessage(message)
        }
        viewModel.removeMessage = {
            self.orderTableView.removeEmptyMessage()
        }
        viewModel.bindResultToTableView = {
            self.orderTableView.reloadData()
        }
        viewModel.displayMessage = { message, isError in
            displayMessage(massage: message, isError: isError)
        }
    }
}

extension AllOrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushViewController(vcIdentifier: "OrderDetailsViewController", withNav: navigationController)
    }
}

extension AllOrdersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        cell.configure(with: viewModel.orders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
