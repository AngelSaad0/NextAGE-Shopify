//
//  WishlistViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import UIKit

class WishlistViewController: UIViewController {
    
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    
    var products: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Wishlist"
        
        wishlistCollectionView.delegate = self
        wishlistCollectionView.dataSource = self
        
        wishlistCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
    }
}

extension WishlistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
#warning("Move to product details vc")
    }
}

extension WishlistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
//        let product = withlistArray[indexPath.row]
//        cell.configure(with: product)
        return cell
    }
    
    
}

extension WishlistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 25
        return CGSize(width: width, height: collectionView.frame.width - 120)
    }
}
