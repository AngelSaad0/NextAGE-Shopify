//
//  HomeViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 02/09/2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var brandsCollection: UICollectionView!
    @IBOutlet var adsCollectionView: UICollectionView!

    @IBOutlet var adsPageControl: UIPageControl!
    let offersList = ["1","2","3","4","5","1","2","3","4","5"]
    var currentPage = 0
    var timer:Timer?



    override func viewDidLoad() {
        super.viewDidLoad()

        startTimer()
        adsPageControl.numberOfPages = offersList.count

    }
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
    }

    @objc func timeAction() {
        let scrollPostion = (currentPage<offersList.count-1) ? currentPage+1 : 0
        adsCollectionView.scrollToItem(at: IndexPath(item: scrollPostion, section: 0), at: .centeredHorizontally, animated: true)

    }


}
extension HomeViewController:UICollectionViewDelegate {


}

extension HomeViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offersList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag  {
        case 0 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionCell", for: indexPath) as! AdsCollectionCell
            let image  = offersList[indexPath.row]
            cell.configure(with: adsModel(image: image))
            return cell
        case 1 :
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionCell", for: indexPath) as! BrandsCollectionCell
            let image  = offersList[indexPath.row]
            cell.configure(with: adsModel(image: image))
            return cell

        default:
            let  cell = UICollectionViewCell()
            return cell
        }

    }



}
extension HomeViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0 :
            return AdsLayoutSize(for: collectionView)

        default:
            return BrandsLayoutSize(for: collectionView)

        }
    }



    private func AdsLayoutSize(for collectionView: UICollectionView) -> CGSize {
        let Width = collectionView.bounds.width
        let height = collectionView.bounds.height
        return(CGSize(width: Width, height: height))
    }

    private func BrandsLayoutSize(for collectionView: UICollectionView) -> CGSize {
        let numberOfCellInRow: CGFloat = 2
        let collectionViewWidth = collectionView.bounds.width
        let adjustWidth = collectionViewWidth-60
        let width = adjustWidth/numberOfCellInRow
        return CGSize(width: width, height: width)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 0 {
            currentPage = Int(scrollView.contentOffset.x/scrollView.frame.width)
            adsPageControl.currentPage = currentPage

        }
    }

}


