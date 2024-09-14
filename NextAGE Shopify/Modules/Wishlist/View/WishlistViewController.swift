//
//  WishlistViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import UIKit

class WishlistViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var wishlistTableView: UITableView!
    // MARK: - Properties
    var viewModel:WishlistViewModel
    let indicator = UIActivityIndicatorView(style: .large)

    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = WishlistViewModel()
        super.init(coder: coder)
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
        viewModel.checkInternetConnection()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkInternetConnection()
    }
    // MARK: - Private Methods
    private func updateUI() {
        title = "My Wishlist"
        setupIndicator()
    }
    private func setupIndicator() {
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }

    private func setupViewModel() {
        viewModel.showNoInternetAlert = {
            self.showNoInternetAlert()
        }
        viewModel.displayEmptyMessage = { message in
            self.wishlistTableView.displayEmptyMessage(message)
        }
        viewModel.removeEmptyMessage = {
            self.wishlistTableView.removeEmptyMessage()
        }
        viewModel.bindResultToTableView = {
            DispatchQueue.main.async {
                self.wishlistTableView.reloadData()
            }
        }
        viewModel.setIndicator = { [weak self] state in
            DispatchQueue.main.async {
                state ? self?.indicator.startAnimating():self?.indicator.stopAnimating()
            }
        }
    }
}
// MARK: - UITableViewDelegate
extension WishlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.viewModel.productID = viewModel.wishlist[indexPath.row].productID
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }

}
// MARK: - UITableViewDataSource
extension WishlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.wishlist.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishLIstTableViewCell", for: indexPath) as! WishlistTableViewCell
        cell.configureForWishlist(with: viewModel.wishlist[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        #warning("remove from wishList")

    }
}


