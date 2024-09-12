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
    let viewModel: SettingsViewModel
    
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = SettingsViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        title = "Settings"
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        logoutButton.addCornerRadius(radius: 8)
        logoutButton.isHidden = !viewModel.isLogin()
    }
    
    private func setupViewModel() {
        viewModel.navigateToAddress = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
            vc.isSettings = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        viewModel.navigateToCurrency = {
            self.pushViewController(vcIdentifier: "CurrencyViewController", withNav: self.navigationController)
        }
        viewModel.navigateToAbout = {
            self.pushViewController(vcIdentifier: "AboutViewController", withNav: self.navigationController)
        }
    }
    
    // MARK: - IBActions
    @IBAction func logoutButton(_ sender: Any) {
        showAlert(title: "Logout?", message: "Are you sure you want to logout?", okTitle: "Yes", cancelTitle: "No", okStyle: .destructive, cancelStyle: .cancel) { _ in
            self.viewModel.logout()
            UIWindow.setRootViewController(vcIdentifier: "AuthOptionsNavigationController")
        } cancelHandler: {_ in}
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.settingDidSelect(at: indexPath.row)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSettingsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingCell
        cell.config(label: viewModel.getSettingLabel(index: indexPath.row), imageName: viewModel.getSettingImageName(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}
