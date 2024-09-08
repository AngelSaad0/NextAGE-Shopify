//
//  CurrencyViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

class CurrencyViewController: UIViewController {
    @IBOutlet weak var currencyTableView: UITableView!

    let userDefaultsManager: UserDefaultManager
    let currencies = ["USD", "EGP", "SAR", "AED"]
    
    
    required init?(coder: NSCoder) {
        userDefaultsManager = UserDefaultManager.shared
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Currency"
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        // Do any additional setup after loading the view.
    }


}

extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userDefaultsManager.currency = currencies[indexPath.row]
        userDefaultsManager.storeData()
        self.navigationController?.popViewController(animated: true)
    }
}

extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.viewWithTag(3)?.addCornerRadius(radius: 12)
        cell.viewWithTag(3)?.addBorderView()
        (cell.viewWithTag(1) as! UILabel).text = currencies[indexPath.row]
        if userDefaultsManager.currency == currencies[indexPath.row] {
            cell.viewWithTag(2)?.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
