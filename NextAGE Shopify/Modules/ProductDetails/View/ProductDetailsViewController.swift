//
//  ProductDetailsViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 02/09/2024.
//

import UIKit

class ProductDetailsViewController: UIViewController {


    
    @IBOutlet var size: UIButton!
    @IBOutlet var ProductPhotosCollectionview: UICollectionView!
    var indexOfSize = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        ProductPhotosCollectionview.dataSource = self
        ProductPhotosCollectionview.delegate = self
    
        setProductPhotosCollectionviewLayout()
          
         
    }
    




}

//MARK: collectionView
extension ProductDetailsViewController :UICollectionViewDelegate,UICollectionViewDataSource {
    private func setProductPhotosCollectionviewLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            return self.createProductPhotosSection()
            
        }
        ProductPhotosCollectionview.collectionViewLayout = layout
    }
    
    func createProductPhotosSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.97), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}
//MARK: sizeStepper


