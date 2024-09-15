//
//  CategoriesViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import UIKit
import Kingfisher

class CategoriesAndBrandsViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var categoryOrBrandCollectionView: UICollectionView!
    @IBOutlet var brandFilterView: UIView!
    @IBOutlet var subCategorySegmentControl: UISegmentedControl!
    @IBOutlet var categorySegmentControl: UISegmentedControl!
    @IBOutlet var sortingOptionsView: UIView!
    @IBOutlet var itemsCountLabel: UILabel!
    @IBOutlet var brandLogoImageView: UIImageView!
    
    // MARK: - Properties
    let viewModel:CategoriesAndBrandsViewModel
    private let indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initializer
    required init?(coder: NSCoder) {
        viewModel = CategoriesAndBrandsViewModel()
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
        configureUIForCurrentScreen()
        setupActivityIndicator()
        checkInternetConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetUI()
        checkInternetConnection()
        categoryOrBrandCollectionView.reloadData()
    }
    
    // MARK: - private Methods
    private  func updateUI() {
        if viewModel.isBrandScreen {
            title = "NextAGE"
        }
        categoryOrBrandCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
    }
    
    private func resetUI() {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        categorySegmentControl.selectedSegmentIndex = 0
        subCategorySegmentControl.selectedSegmentIndex = 0
    }
    
    private func setupViewModel(){
        viewModel.bindResultTable = {
            DispatchQueue.main.async { [weak self] in
                self?.categoryOrBrandCollectionView.reloadData()
            }
        }
        viewModel.setIndicator = { state in
            DispatchQueue.main.async { [weak self] in
                state ? self?.indicator.startAnimating() : self?.indicator.stopAnimating()
            }
        }
        viewModel.displayEmptyMessage = { message in
            self.categoryOrBrandCollectionView.displayEmptyMessage(message)
        }
        viewModel.removeEmptyMessage = {
            self.categoryOrBrandCollectionView.removeEmptyMessage()
        }
        viewModel.updateItemsCount = { labelText in
            DispatchQueue.main.async { [weak self] in
                self?.itemsCountLabel.text =  labelText
            }
        }
    }
    
    private func configureUIForCurrentScreen() {
        brandFilterView.isHidden = viewModel.isBrandScreen
        sortingOptionsView.isHidden = !viewModel.isBrandScreen
        if viewModel.isBrandScreen {
            brandLogoImageView.kf.setImage(with: URL(string: viewModel.brandLogoURL ?? ""), placeholder: UIImage(named: "loading"))
        }
    }
    private func setupActivityIndicator() {
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    private func checkInternetConnection() {
        viewModel.connectivityService.checkInternetConnection { [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                self.viewModel.loadProducts()
            } else {
                self.indicator.stopAnimating()
                self.showNoInternetAlert()
                self.categoryOrBrandCollectionView.displayEmptyMessage("No Items In Stock")
            }
        }
    }
    // MARK: -  Actions
    
    @IBAction func categorySegmentControlClicked(_ sender: UISegmentedControl) {
        viewModel.selectedCategory = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "All"
        viewModel.applyFiltersAndSearch()
    }
    
    @IBAction func subCategorySegmentControlClicked(_ sender: UISegmentedControl) {
        viewModel.selectedSubCategory = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "All"
        viewModel.applyFiltersAndSearch()
    }
    
    @IBAction func sortButtonClicked(_ sender: UIButton) {
        viewModel.filteredOrSortedProducts.sort {
            ((Double($0.variants[0].price) ?? 0.0) > (Double($1.variants[0].price) ?? 0.0)) == viewModel.isFilterApplied
        }
        viewModel.isFilterApplied.toggle()
        categoryOrBrandCollectionView.reloadData()
    }
}

// MARK: - Collection View Data Source and Delegate Methods

extension CategoriesAndBrandsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.viewModel.productID = viewModel.filteredOrSortedProducts[indexPath.row].id
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}

extension CategoriesAndBrandsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredOrSortedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        let product = viewModel.filteredOrSortedProducts[indexPath.row]
        cell.product = product
        cell.configure(with: product)
        cell.showLoginAlert = {
            self.showLoginFirstAlert(to: "add this product to wishlist")
        }
        return cell
    }
    
}

extension CategoriesAndBrandsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 25
        return CGSize(width: width, height: collectionView.frame.width - 120)
    }
}

// MARK: - Search Bar Delegate Methods
extension CategoriesAndBrandsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        viewModel.isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        viewModel.isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchProducts(with: searchText.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            viewModel.searchProducts(with: searchText)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        viewModel.searchProducts(with: "")
    }
    
}
