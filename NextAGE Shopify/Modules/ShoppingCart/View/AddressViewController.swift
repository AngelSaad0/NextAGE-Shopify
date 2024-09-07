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
    
    let addresses = [
        ("Eiffel tower, floor 7", "gps"),
        ("Eiffel tower, floor 9", "gps")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Address"
        
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        
        selectPayment.isEnabled = false
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addAddressButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func selectPaymentButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in addresses.indices {
            (tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! PaymentMethodCell).deselect()
        }
        (tableView.cellForRow(at: indexPath) as! PaymentMethodCell).select()
        selectPayment.isEnabled = true
    }
}

extension AddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentMethodCell
        cell.config(methodName: addresses[indexPath.row].0, methodImageName: addresses[indexPath.row].1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

