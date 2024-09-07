//
//  MeViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/6/24.
//

import UIKit

class MeViewController: UIViewController {
    // MARK: -  @IBOutlet

    @IBOutlet var logInStack: UIStackView!
    @IBOutlet weak var userGreetingLabel: UILabel!
    @IBOutlet weak var ordersListTableView: UITableView!
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    @IBOutlet weak var notLoggedInView: UIView!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var logInButton: UIButton!

    // MARK: -  Properties
    private var networkManager:NetworkManager
    private var userDefaultManager:UserDefaultManager
    private var connectivityService:ConnectivityServiceProtocol
    var orderListResult: Orders?
    var wishListResult: [LineItem] = []
    var currentCustomerId: Int?
    var currentCustomerName: String?
    var isUserLoggedIn: Bool?

    // MARK: -  View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        orderListResult = Orders(orders: [])
        checkInternetConnection()
        updateUI()
    }

    // MARK: - Required init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultManager = UserDefaultManager.shared
        connectivityService = ConnectivityService.shared
        super.init(coder: coder)
    }
    private func updateUI() {
        ordersListTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
        isUserLoggedIn = userDefaultManager.isLogin
        registerButton.addCornerRadius(radius: 12)
        logInButton.addCornerRadius(radius: 12)
        wishlistCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
    }
    // MARK: -  private Method
    private func getOrderListData() {
        if (orderListResult?.orders.count  == 0) {
            // ordersListTableView.displayEmptyMessage("No Orders Yet ")
        } else {
            ordersListTableView.removeEmptyMessage()
        }
    }
    private func loadWishlistData() {
    }

    private func checkInternetConnection() {
        connectivityService.checkInternetConnection { [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                if self.isUserLoggedIn ?? false{
                    self.logInStack.isHidden = false
                    self.notLoggedInView.isHidden = true
                    self.userGreetingLabel.text = "Welcome \(self.currentCustomerName ?? "")"
                    self.getOrderListData()
                    self.loadWishlistData()
                } else {
                    self.notLoggedInView.isHidden = false
                    self.logInStack.isHidden = true
                }
            } else {
                self.showNoInternetAlert()
            }
        }
    }
    // MARK: -  Method
    @IBAction func viewAllOrdersClicked(_ sender: UIButton) {
        pushViewController(storyboard: "Main", vcIdentifier: "OrderViewController", withNav: navigationController)

    }
    @IBAction func viewAllWishListClicked(_ sender: UIButton) {
#warning("will changed to go to wishlist ")
        pushViewController(storyboard: "Main", vcIdentifier: "OrderViewController", withNav: navigationController)

    }

    @IBAction func logInButtonClicked(_ sender: UIButton) {
        pushViewController(storyboard: "Main", vcIdentifier: "SignInViewController", withNav: navigationController)
    }
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        pushViewController(storyboard: "Main", vcIdentifier: "SignUpViewController", withNav: navigationController)


    }



}

// MARK: - TableView DataSource & Delegate

extension MeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        //cell.configure(with: T##Order)
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
// MARK: - CollectionView DataSource & Delegate
extension MeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        // let wishlistItem = wishListResult[indexPath.row]
        // cell.configure(with: wishlistItem)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let width = collectionView.frame.width / 2 - 18
        //        return CGSize(width: width, height: 200)
        return CGSize(width:collectionView.frame.width/2 - 18 , height: collectionView.frame.height)

    }
}

