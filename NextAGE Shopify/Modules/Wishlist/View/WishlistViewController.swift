//
//  WishlistViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import UIKit

class WishlistViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
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
        wishlistCollectionView.delegate = self
        wishlistCollectionView.dataSource = self
        wishlistCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
        setupIndicator()
    }
    private func setupIndicator() {
        indicator.center = view.center
        view.addSubview(indicator)
    }

    private func setupViewModel(){
        viewModel.displayEmptyMessage = { message in
            self.wishlistCollectionView.displayEmptyMessage(message)
        }
        viewModel.removeEmptyMessage = {
            self.wishlistCollectionView.removeEmptyMessage()
        }
        viewModel.bindResultToTableView = {
            DispatchQueue.main.async {
                self.wishlistCollectionView.reloadData()
            }
        }
        viewModel.setIndicator = { [weak self] state in
            DispatchQueue.main.async {
                state ? self?.indicator.startAnimating():self?.indicator.stopAnimating()
            }
        }
    }
}

extension WishlistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.viewModel.productID = viewModel.wishlist[indexPath.row].productID
        navigationController?.pushViewController(productDetailsViewController, animated: true)

    }
}

extension WishlistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.wishlist.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        cell.configureForWishlist(with: viewModel.wishlist[indexPath.row])
        return cell
    }


}

extension WishlistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 25
        return CGSize(width: width, height: collectionView.frame.height/2.2)
    }
}
