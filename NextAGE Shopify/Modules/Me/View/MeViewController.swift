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
    var currentCustomerName: String?
#warning("delte default value of isUserLoggedIn ")
    var isUserLoggedIn: Bool = true
    var currentCustomerId: Int?
    var wishlistProducts: [ProductInfo]?

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
#warning("uncomment UserLoggedIn ")
        //isUserLoggedIn = userDefaultManager.isLogin
        currentCustomerId = userDefaultManager.customerID
        registerButton.addCornerRadius(radius: 12)
        logInButton.addCornerRadius(radius: 12)
        wishlistCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
        ordersListTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")

    }
    // MARK: -  private Method
    private func checkInternetConnection() {
            connectivityService.checkInternetConnection { [weak self] isConnected in
                guard let self = self else { return }
                if isConnected {
                    self.updateUIForLoginState()
                } else {
                    self.showNoInternetAlert()
                }
            }
        }
     private func updateUIForLoginState() {
        if isUserLoggedIn ?? false{
            logInStack.isHidden = false
            notLoggedInView.isHidden = true
            userGreetingLabel.text = "Welcome \(currentCustomerName ?? "Sir")"
            loadOrderListData()
            loadWishlistData()
        } else {
            notLoggedInView.isHidden = false
            logInStack.isHidden = true
        }
    }
    private func loadOrderListData() {
        if (orderListResult?.orders.count  == 0) {
             ordersListTableView.displayEmptyMessage("No Orders Yet ")
        } else {
            ordersListTableView.removeEmptyMessage()
        }
    }
    private func loadWishlistData() {
    }
    // MARK: -  Method
    @IBAction func viewAllOrdersClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "AllOrdersViewController", withNav: navigationController)

    }
    @IBAction func viewAllWishListClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "WishlistViewController", withNav: navigationController)
    }

    @IBAction func logInButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "SignInViewController", withNav: navigationController)
    }
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "SignUpViewController", withNav: navigationController)


    }

}

// MARK: - TableView DataSource & Delegate

extension MeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("uncomment")//orderListResult?.orders.count ?? 0
        return 10

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
#warning("uncomment two line to confinge cell")
//        if let order = orderListResult?.orders[indexPath.row] {
//            cell.configure(with: order)
//        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("yes")
        pushViewController(vcIdentifier: "AllOrdersViewController", withNav: navigationController)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
// MARK: - CollectionView DataSource & Delegate
extension MeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
#warning("uncomment ")
        //wishListResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
#warning("uncomment line to confinge cell")
      //cell.configure(with: wishListResult[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.productID = wishlistProducts?[indexPath.row].id ?? 0
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width/2 - 18 , height: collectionView.frame.height)

    }
}

