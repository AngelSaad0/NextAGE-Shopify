//
//  WishlistViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import UIKit

class WishlistViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var wishlistTablView: UITableView!
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
        viewModel.fetchWishlist()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchWishlist()
    }
    // MARK: - Private Methods
    private func updateUI() {
        title = "My Wishlist"
        setupIndicator()
    }
    private func setupIndicator() {
        indicator.center = view.center
        view.addSubview(indicator)
    }

    private func setupViewModel(){
        viewModel.displayEmptyMessage = { message in
            self.wishlistTablView.displayEmptyMessage(message)
        }
        viewModel.removeEmptyMessage = {
            self.wishlistTablView.removeEmptyMessage()
        }
        viewModel.bindResultToTableView = {
            DispatchQueue.main.async {
                self.wishlistTablView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishLIstTableViewCell", for: indexPath) as! WishLIstTableViewCell
        cell.configureForWishlist(with: viewModel.wishlist[indexPath.row])
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        #warning("remove from wishList")

    }
}


