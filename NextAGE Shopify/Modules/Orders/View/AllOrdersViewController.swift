//
//  OrderViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/7/24.
//

import UIKit

class AllOrdersViewController: UIViewController {

    @IBOutlet var orderTableView: UITableView!
    var orderListResult: Orders?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Orders"
        orderListResult = Orders(orders: [])
        orderTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
        orderTableView.delegate = self
        orderTableView.dataSource = self
    }
}

extension AllOrdersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        //orderListResult?.orders.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
        
    }

}
