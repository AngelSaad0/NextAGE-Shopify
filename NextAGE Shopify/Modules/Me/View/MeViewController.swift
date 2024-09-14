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
    private var viewModel: MeViewModel!
    private let ordersIndicator = UIActivityIndicatorView(style: .large)
    private let wishlistIndicator = UIActivityIndicatorView(style: .large)

    // MARK: -  View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        viewModel.checkInternetConnection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.isUserLoggedIn {
            viewModel.updateUserOrders()
            viewModel.loadWishlistData()
        }
    }

    private func setupViewModel() {
        viewModel = MeViewModel(networkManager: NetworkManager(), userDefaultsManager: UserDefaultManager.shared, connectivityService: ConnectivityService.shared)

        viewModel.onOrdersUpdated = { [weak self] in
            self?.updateOrdersUI()
        }

        viewModel.onWishlistUpdated = { [weak self] in
            self?.updateWishlistUI()
        }
        viewModel.ordersIndicator = { 
            self.ordersIndicator.stopAnimating()
        }
        viewModel.wishlistIndicator = {
            self.wishlistIndicator.stopAnimating()

        }

        viewModel.onInternetConnectionChecked = { [weak self] in
            self?.updateUIForLoginState()
        }

        viewModel.onShowNoInternetAlert = { [weak self] in
            self?.showNoInternetAlert()
        }
    }

    private func setupUI() {
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
        ordersIndicator.startAnimating()
        wishlistIndicator.startAnimating()
    }


    private func updateUIForLoginState() {
        if viewModel.isUserLoggedIn {
            logInStack.isHidden = false
            notLoggedInView.isHidden = true
            userGreetingLabel.text = "Welcome \(viewModel.customerName ?? "Sir")"
        } else {
            notLoggedInView.isHidden = false
            logInStack.isHidden = true
        }
    }

    private func updateOrdersUI() {
        ordersIndicator.stopAnimating()
        if viewModel.orders.isEmpty {
            ordersListTableView.displayEmptyMessage("No Orders Yet ")
        } else {
            ordersListTableView.removeEmptyMessage()
        }
        ordersListTableView.reloadData()
    }

    private func updateWishlistUI() {
        wishlistIndicator.stopAnimating()
        if viewModel.wishlist.isEmpty {
            wishlistCollectionView.displayEmptyMessage("Add some products to your wishlist ")
        } else {
            wishlistCollectionView.removeEmptyMessage()
        }
        wishlistCollectionView.reloadData()
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
        return min(viewModel.orders.count, 2)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        cell.configure(with: viewModel.orders[indexPath.row])
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
        return viewModel.wishlist.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        cell.configureForWishlist(with: viewModel.wishlist[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.viewModel.productID = viewModel.wishlist[indexPath.row].productID
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 18, height: collectionView.frame.height)
    }
}
