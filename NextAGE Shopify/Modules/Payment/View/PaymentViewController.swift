//
//  PaymentViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var purchaseButton: UIButton!
    let paymentMethods = [
        ("Cash on delivery", "cash"),
        ("Apple pay", "applePay")
    ]
    
    @IBOutlet weak var paymentMethodsTableView: UITableView!
    @IBOutlet weak var purchase: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Payment method"
        
        purchase.isEnabled = false
        
        paymentMethodsTableView.delegate = self
        paymentMethodsTableView.dataSource = self
        
        purchaseButton.addCornerRadius(radius: 12)
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

    @IBAction func purchaseButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationViewController") as! ConfirmationViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension PaymentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in paymentMethods.indices {
            (tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! PaymentMethodCell).deselect()
        }
        (tableView.cellForRow(at: indexPath) as! PaymentMethodCell).select()
        purchase.isEnabled = true
    }
}

extension PaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentMethodCell
        cell.config(methodName: paymentMethods[indexPath.row].0, methodImageName: paymentMethods[indexPath.row].1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}
