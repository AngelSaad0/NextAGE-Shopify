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
    let networkManager: NetworkManager
    let userDefaultManager: UserDefaultManager
    var orders: [Order] = []
    private let indicator = UIActivityIndicatorView(style: .large)
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultManager = UserDefaultManager.shared
        super.init(coder: coder)
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    // MARK: - Private Methods
    private func updateUI() {
        title = "All Orders"
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
        setupIndicators()
        updateUserOrders()
    }
    private func setupIndicators() {
        indicator.center = view.center
        view.addSubview(indicator)
    }
    private func fetchAllOrders(completion: @escaping ([Order]?)->()) {
        networkManager.fetchData(from: ShopifyAPI.orders.shopifyURLString(), responseType: Orders.self) { result in
            completion(result?.orders)
        }
    }
    private func updateUserOrders() {
        indicator.startAnimating()
        fetchAllOrders { orders in
            self.indicator.stopAnimating()
            guard let orders = orders else {
                displayMessage(massage: .ordersFetchingFailed, isError: true)
                return
            }
            self.orders = orders.filter {$0.customer.id == self.userDefaultManager.customerID}
            if self.orders.count == 0 {
                self.orderTableView.displayEmptyMessage("No Orders Yet ")
            } else {
                self.orderTableView.removeEmptyMessage()
            }
            self.orderTableView.reloadData()
        }
    }
}

extension AllOrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        navigationController?.pushViewController(orderDetailsViewController, animated: true)
    }
}

extension AllOrdersViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        cell.configure(with: orders[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
        
    }

}
