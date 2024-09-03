//
//  HomeViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 02/09/2024.
//

import UIKit

class HomeViewController: UIViewController {
    let offersList = ["add1","add2","add3","add4","add5","add6","add7","add8","add9","add10","add11"]

    @IBOutlet var brandsCollection: UICollectionView!
    @IBOutlet var adsCollectionView: UICollectionView!

    @IBOutlet var adsPageControl: UIPageControl!
    
    var networkManager: NetworkManager
    
    var homeViewModel : HomeViewModel?
    var brandsArray : [SmartCollection]?
    var adsArray : [adsModel]?
    var indicator : UIActivityIndicatorView?
    var loggedIn :Bool?
    var currentPage = 0
    var timer:Timer?

    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        adsPageControl.numberOfPages = offersList.count

        loadBrands()

    }
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = self.brandsCollection.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)

    }
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
    }

    @objc func timeAction() {

        let scrollPostion = (currentPage<offersList.count-1) ? currentPage+1 : 0
        adsCollectionView.scrollToItem(at: IndexPath(item: scrollPostion, section: 0), at: .centeredHorizontally, animated: true)

    }
    
    func loadBrands() {
        networkManager.fetchData(from: ShopifyAPI.smartCollections.shopifyURLString(), responseType: BrandsCollection.self) { result in
            guard let brands = result else {return}
            DispatchQueue.main.async { [weak self] in
                self?.brandsArray = brands.smartCollections
                self?.brandsCollection.reloadData()
            }
        }
    }


}
extension HomeViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
            let brandsVC = storyboard?.instantiateViewController(identifier: "CategoriesViewController") as! CategoriesViewController
                brandsVC.isBrandScreen = true

         navigationController?.pushViewController(brandsVC, animated: true)
        }

    }
}

extension HomeViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0 :
            return offersList.count
        default :
            return (brandsArray ?? []).count

        }

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
            let imageURLString = brandsArray![indexPath.row].image.src
            cell.configure(with: imageURLString)
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
            currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
            adsPageControl.currentPage = currentPage

        }
    }


}


