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
    private var userDefaultsManager:UserDefaultManager
    private var connectivityService:ConnectivityServiceProtocol
    let ordersIndicator = UIActivityIndicatorView(style: .large)
    let wishlistIndicator = UIActivityIndicatorView(style: .large)
    var orders: [Order] = []
    var wishlist: [LineItem] = []
    var customerName: String?
    var isUserLoggedIn: Bool?
    var currentCustomerId: Int?

    // MARK: -  View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternetConnection()
        updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        if isUserLoggedIn ?? false {
            updateUserOrders()
            loadWishlistData()
        }
    }

    // MARK: - Required init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultsManager = UserDefaultManager.shared
        connectivityService = ConnectivityService.shared
        super.init(coder: coder)
    }
    // MARK: -  private Method
    private func updateUI() {
        isUserLoggedIn = userDefaultsManager.isLogin
        currentCustomerId = userDefaultsManager.customerID
        customerName = userDefaultsManager.name == "" ? nil : userDefaultsManager.name
        registerButton.addCornerRadius(radius: 12)
        logInButton.addCornerRadius(radius: 12)
        wishlistCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
        ordersListTableView.register(UINib(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
        setupIndicators()
    }
    private func setupIndicators() {
        ordersIndicator.center = CGPoint(x: view.center.x, y: ordersListTableView.center.y + 80)
        view.addSubview(ordersIndicator)
        wishlistIndicator.center = CGPoint(x: view.center.x, y: wishlistCollectionView.center.y + 80)
        view.addSubview(wishlistIndicator)
    }
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
        if isUserLoggedIn ?? false {
            logInStack.isHidden = false
            notLoggedInView.isHidden = true
            userGreetingLabel.text = "Welcome \(customerName ?? "Sir")"
            updateUserOrders()
            loadWishlistData()
        } else {
            notLoggedInView.isHidden = false
            logInStack.isHidden = true
        }
    }
    private func updateUserOrders() {     
        ordersIndicator.startAnimating()
        fetchAllOrders { orders in
            self.ordersIndicator.stopAnimating()
            guard let orders = orders else {
                self.ordersListTableView.displayEmptyMessage("No Orders Yet ")
                displayMessage(massage: .ordersFetchingFailed, isError: true)
                return
            }
            self.orders = orders.filter {$0.customer.id == self.currentCustomerId}
            if (self.orders.count == 0) {
                self.ordersListTableView.displayEmptyMessage("No Orders Yet ")
            } else {
                self.ordersListTableView.removeEmptyMessage()
            }
            self.ordersListTableView.reloadData()
        }
    }
    private func loadWishlistData() {
        wishlistIndicator.startAnimating()
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultsManager.wishlistID).shopifyURLString(), responseType: DraftOrderWrapper.self) { result in
            self.wishlist = result?.draftOrder.lineItems ?? []
            if self.wishlist.first?.variantID == nil {
                self.wishlist = Array(self.wishlist.dropFirst())
            }
            self.wishlistIndicator.stopAnimating()
            if self.wishlist.count == 0 {
                self.wishlistCollectionView.displayEmptyMessage("Add some products to your wishlist ")
            } else {
                self.wishlistCollectionView.removeEmptyMessage()
            }
            self.wishlistCollectionView.reloadData()
            
        }
    }
    private func fetchAllOrders(completion: @escaping ([Order]?)->()) {
        networkManager.fetchData(from: ShopifyAPI.orders.shopifyURLString(), responseType: Orders.self) { result in
            completion(result?.orders)
        }
    }
    // MARK: - IBActions
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
        return min(orders.count, 2)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        cell.configure(with: orders[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushViewController(vcIdentifier: "AllOrdersViewController", withNav: navigationController)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
// MARK: - CollectionView DataSource & Delegate
extension MeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlist.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        cell.configureForWishlist(with: wishlist[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.productID = wishlist[indexPath.row].productID
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width/2 - 18 , height: collectionView.frame.height)

    }
}

