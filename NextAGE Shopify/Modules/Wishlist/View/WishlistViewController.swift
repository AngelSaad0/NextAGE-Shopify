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
    let networkManager: NetworkManager
    let userDefaultsManager: UserDefaultManager
    var wishlist: [LineItem] = []
    let indicator = UIActivityIndicatorView(style: .large)
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultsManager = UserDefaultManager.shared
        super.init(coder: coder)
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        fetchWishlist()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWishlist()
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
    private func fetchWishlist() {
        indicator.startAnimating()
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultsManager.wishlistID).shopifyURLString(), responseType: DraftOrderWrapper.self) { result in
            self.wishlist = result?.draftOrder.lineItems ?? []
            if self.wishlist.first?.variantID == nil {
                self.wishlist = Array(self.wishlist.dropFirst())
            }
            self.indicator.stopAnimating()
            if self.wishlist.count == 0 {
                self.wishlistCollectionView.displayEmptyMessage("Add some products to your wishlist ")
            } else {
                self.wishlistCollectionView.removeEmptyMessage()
            }
            self.wishlistCollectionView.reloadData()
            
        }
    }
}

extension WishlistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.viewModel.productID = wishlist[indexPath.row].productID
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}

extension WishlistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        cell.configureForWishlist(with: wishlist[indexPath.row])
        return cell
    }
    
    
}

extension WishlistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 25
        return CGSize(width: width, height: collectionView.frame.height/2.2)
    }
}
