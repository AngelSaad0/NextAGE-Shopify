//
//  SettingsViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    let settings = [
        ("Address", "gps"),
        ("Currency", "transfer"),
        ("About", "information")
    ]

    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        logoutButton.addCornerRadius(radius: 8)
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
    @IBAction func logoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let story = UIStoryboard(name: "Main", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "MainNavigationController")
                window.rootViewController = vc
                window.makeKeyAndVisible()
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        self.present(alert, animated: true)
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController
        switch indexPath.row {
        case 0:
            vc = storyboard.instantiateViewController(withIdentifier: "CurrencyViewController")
        case 1:
            vc = storyboard.instantiateViewController(withIdentifier: "CurrencyViewController")
        default:
            vc = storyboard.instantiateViewController(withIdentifier: "AboutViewController")
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingCell
        cell.config(label: settings[indexPath.row].0, imageName: settings[indexPath.row].1)
        return cell
    }
    
    
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}
