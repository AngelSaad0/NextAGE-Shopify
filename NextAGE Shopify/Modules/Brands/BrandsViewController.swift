//
//  BrandsViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import UIKit

class BrandsViewController: UIViewController {
    @IBOutlet weak var ItemsCollection: UICollectionView!
    @IBOutlet weak var itemsCount: UILabel!

    @IBOutlet weak var brandLogo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func sortBtnPressed(_ sender: Any) {
    }
    


}

extension BrandsViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandItemCollectionCell", for: indexPath) as! BrandItemCollectionCell
        return cell
    }
    


}
extension BrandsViewController:UICollectionViewDelegate {

}
extension BrandsViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 2 - 5
        return CGSize(width: width, height: collectionView.frame.width-20)
    }



}

