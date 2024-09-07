//
//  ProductDetailsViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 02/09/2024.
//

import UIKit

class ProductDetailsViewController: UIViewController {


    @IBOutlet var productCollectionView: UICollectionView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet var productRatingButton: [UIButton]!
    @IBOutlet weak var productSizeButton: UIButton!
    @IBOutlet weak var productColorButton: UIButton!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet var reviewTableView: UITableView!

    @IBOutlet var addToChartButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addToChartButton.addCornerRadius(radius: 12)
        productSizeButton.addCornerRadius(radius: 12)
        productColorButton.addCornerRadius(radius: 12)

        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
        setProductPhotosCollectionviewLayout()
          
        reviewTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
    }
    
    
    @IBAction func viewAllReviewsButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "AllReviewsViewController", withNav: navigationController)
    }
}

//MARK: collectionView
extension ProductDetailsViewController :UICollectionViewDelegate,UICollectionViewDataSource {
    private func setProductPhotosCollectionviewLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            return self.createProductPhotosSection()
            
        }
        productCollectionView.collectionViewLayout = layout
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
        return min(2, 10)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
