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
    @IBOutlet var reviewTableView: UITableView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        ProductPhotosCollectionview.dataSource = self
        ProductPhotosCollectionview.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
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

//MARK: Reviews tabel view
extension ProductDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath)
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(140)
    }
}
