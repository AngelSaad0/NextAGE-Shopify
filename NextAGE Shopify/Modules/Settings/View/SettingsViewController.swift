//
//  SettingsViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    // MARK: - Properties
    let userDefaultsManager: UserDefaultManager
    let settingsLabelImageOptions = [
        ("Address", "gps"),
        ("Currency", "transfer"),
        ("About", "information")
    ]
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        userDefaultsManager = UserDefaultManager.shared
        super.init(coder: coder)
    }
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    // MARK: - Private Methods
    private func updateUI() {
        title = "Settings"
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        logoutButton.addCornerRadius(radius: 8)
        logoutButton.isHidden = !userDefaultsManager.isLogin
    }
    // MARK: - IBActions
    @IBAction func logoutButton(_ sender: Any) {
        showAlert(title: "Logout?", message: "Are you sure you want to logout?", okTitle: "Yes", cancelTitle: "No", okStyle: .destructive, cancelStyle: .cancel) { _ in
            self.userDefaultsManager.logout()
            UIWindow.setRootViewController(vcIdentifier: "AuthOptionsNavigationController")
        } cancelHandler: {_ in}
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
            vc.isSettings = true
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            pushViewController(vcIdentifier: "CurrencyViewController", withNav: navigationController)
        default:
            pushViewController(vcIdentifier: "AboutViewController", withNav: navigationController)
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingCell
        cell.config(label: settingsLabelImageOptions[indexPath.row].0, imageName: settingsLabelImageOptions[indexPath.row].1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
}
