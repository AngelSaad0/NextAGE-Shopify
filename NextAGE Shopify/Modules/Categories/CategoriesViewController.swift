//
//  CategoriesViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import UIKit

class CategoriesViewController: UIViewController {
    let offersList = ["6","7","8","9","10","6","7","8","9","10",]
    var isBrandScreen:Bool = false

    @IBOutlet var filtterView: UIView!
    @IBOutlet var sortView: UIView!

    @IBOutlet var CategoriesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()


    }
    func  updateUI() {
        filtterView.isHidden = isBrandScreen
        sortView.isHidden = !isBrandScreen

    }


}
extension CategoriesViewController:UICollectionViewDelegate {

}
extension CategoriesViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offersList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        let image  = offersList[indexPath.row]
        cell.configure(with: adsModel(image: image))
        return cell
    }


}
extension CategoriesViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 2 - 10
        return CGSize(width: width, height: collectionView.frame.width-80)
    }


}
