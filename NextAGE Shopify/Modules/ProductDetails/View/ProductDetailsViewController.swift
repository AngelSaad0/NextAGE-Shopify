//
//  ProductDetailsViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 02/09/2024.
//

import UIKit
import Kingfisher

class ProductDetailsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var productCollectionView: UICollectionView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet var productRatingButton: [UIButton]!
    @IBOutlet weak var productSizeButton: UIButton!
    @IBOutlet weak var productColorButton: UIButton!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet var reviewTableView: UITableView!
    @IBOutlet weak var viewAllReviewsButton: UIButton!
    @IBOutlet var addToChartButton: UIButton!
    // MARK: - Properties
    let indicator = UIActivityIndicatorView(style: .large)
    let networkManager: NetworkManager
    var productID: Int?
    var product: ProductInfo?
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupIndicator()
        setProductPhotosCollectionviewLayout()
        fetchProduct()
    }
    
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        super.init(coder: coder)
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        title = "NextAGE"
        addToChartButton.addCornerRadius(radius: 12)
        productSizeButton.addCornerRadius(radius: 12)
        productColorButton.addCornerRadius(radius: 12)
        reviewTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
    }
    
    private func setupIndicator() {
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    private func updateProductInfo() {
        viewAllReviewsButton.isEnabled = true
        productSizeButton.isEnabled = true
        productColorButton.isEnabled = true
        productTitleLabel.text = product?.title
        productPriceLabel.text = product?.variants.first?.price
        #warning("product review")
        productDescriptionTextView.text = product?.bodyHTML
        reviewTableView.reloadData()
        productCollectionView.reloadData()
    }
    
    private func presentError() {
        indicator.stopAnimating()
        showAlert(title: "Error happened", message: "An unexpected error loading product info", okHandler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    private func fetchProduct() {
        guard let productID = productID else {
            print("ID not sent from previous view")
            presentError()
            return
        }
        print(productID)
        networkManager.fetchData(from: ShopifyAPI.product(id: productID).shopifyURLString(), responseType: Product.self) { result in
            self.indicator.stopAnimating()
            guard let product = result?.product else {
                self.presentError()
                return
            }
            self.product = product
            self.updateProductInfo()
        }
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
        return product?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: product!.images[indexPath.row].src))
        return cell
    }
}
//MARK: sizeStepper

//MARK: Reviews tabel view
extension ProductDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product == nil ? 0 : 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
