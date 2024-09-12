//
//  CategoriesViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import UIKit
import Combine
import Kingfisher

class CategoriesAndBrandsViewController: UIViewController {
    // MARK: -  @IBOutlet
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var categoryOrBrandCollectionView: UICollectionView!
    @IBOutlet var brandFilterView: UIView!
    @IBOutlet var subCategorySegmentControl: UISegmentedControl!
    @IBOutlet var categorySegmentControl: UISegmentedControl!
    @IBOutlet var sortingOptionsView: UIView!
    @IBOutlet var itemsCountLabel: UILabel!
    @IBOutlet var brandLogoImageView: UIImageView!

    // MARK: -  Properties
    var isBrandScreen: Bool = false
    var isSearching: Bool = false
    var isFilterApplied: Bool = false
    var isSearchActive: Bool = false
    var searchKeyword: String = ""
    var selectedCategory: String?
    var selectedSubCategory: String?
    var selectedVendor: String?
    var brandLogoURL: String?
    var id: Int?
    var networkManager: NetworkManager
    var connectivityService: ConnectivityServiceProtocol
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var itemsCountPublisher = PassthroughSubject<Int, Never>()
    private var cancellables = Set<AnyCancellable>()
    var productResults: [ProductInfo] = []
    var filteredOrSortedProducts: [ProductInfo] = [] {
        didSet {
            itemsCountLabel.text = "\(filteredOrSortedProducts.count) Items"
        }
    }

    // MARK: -  required init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        connectivityService = ConnectivityService.shared
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureUIForCurrentScreen()
        setupActivityIndicator()
        checkInternetConnection()
        setupSearchTextPublisher()
    }

    override func viewWillAppear(_ animated: Bool) {
        categoryOrBrandCollectionView.reloadData()
    }

    // MARK: -  Action
    @IBAction func categorySegmentControlClicked(_ sender: UISegmentedControl) {
        selectedCategory = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "All"
        applyFiltersAndSearch()
    }

    @IBAction func subCategorySegmentControlClicked(_ sender: UISegmentedControl) {
        selectedSubCategory = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "All"
        applyFiltersAndSearch()
    }

    @IBAction func sortButtonClicked(_ sender: UIButton) {
        filteredOrSortedProducts.sort {
            ((Double($0.variants[0].price) ?? 0.0) > (Double($1.variants[0].price) ?? 0.0)) == isFilterApplied
        }
        isFilterApplied.toggle()
        categoryOrBrandCollectionView.reloadData()
    }

    func filterResults(category: String = "All", subCategory: String = "All") {
        var filteredResults = productResults

        switch category {
        case "Women":
            filteredResults = filteredResults.filter { product in
                product.tags.contains("women")
            }
        case "Men":
            filteredResults = filteredResults.filter { product in
                product.tags.contains("men") && !product.tags.contains("women")
            }
        case "Kids":
            filteredResults = filteredResults.filter { product in
                product.tags.contains("kids")
            }
        default:
            filteredResults = productResults
        }

        if subCategory == "Accessories" || subCategory == "T-Shirts" || subCategory == "Shoes" {
            filteredResults = filteredResults.filter { product in
                product.productType.rawValue == subCategory.uppercased()
            }
        }

        if !searchKeyword.isEmpty {
            filteredResults = filteredResults.filter { product in
                product.title.lowercased().contains(searchKeyword.lowercased())
            }
        }

        filteredOrSortedProducts = filteredResults
        updateUIForNoResults()
        categoryOrBrandCollectionView.reloadData()
    }

    private func applyFiltersAndSearch() {
        filterResults(category: selectedCategory ?? "All", subCategory: selectedSubCategory ?? "All")
    }

    private func updateUIForNoResults() {
        if filteredOrSortedProducts.isEmpty {
            categoryOrBrandCollectionView.displayEmptyMessage("No Items In Stock")
        } else {
            categoryOrBrandCollectionView.removeEmptyMessage()
        }
    }

    func updateUI() {
        if isBrandScreen {
            title = "NextAGE"
        }
        categoryOrBrandCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
    }

    func configureUIForCurrentScreen() {
        brandFilterView.isHidden = isBrandScreen
        sortingOptionsView.isHidden = !isBrandScreen
        if isBrandScreen {
            brandLogoImageView.kf.setImage(with: URL(string: brandLogoURL ?? ""), placeholder: UIImage(named: "loading"))
        }
    }

    // MARK: -  private Method
    private func setupSearchTextPublisher() {
        searchTextSubject
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchProducts(with: searchText)
            }
            .store(in: &cancellables)
    }

    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    private func checkInternetConnection() {
        connectivityService.checkInternetConnection { [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                loadProducts()
            } else {
                self.showNoInternetAlert()
            }
        }
    }
    private func loadProducts() {
        networkManager.fetchData(from: ShopifyAPI.products.shopifyURLString(), responseType: Products.self) { result in
            guard let products = result else {return}
            DispatchQueue.main.async { [weak self] in
                if self?.isBrandScreen ?? false {
                    self?.productResults = products.products.filter { $0.vendor == self?.selectedVendor }
                } else {
                    self?.productResults = products.products
                }
                self?.filteredOrSortedProducts = self?.productResults ?? []
                self?.itemsCountPublisher.send(self?.filteredOrSortedProducts.count ?? 0)
                self?.categoryOrBrandCollectionView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }

    private func searchProducts(with searchText: String) {
        searchKeyword = searchText
        applyFiltersAndSearch()
    }
}

// MARK: -  Collection View Data Source and Delegate Methods

extension CategoriesAndBrandsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.viewModel.productID = filteredOrSortedProducts[indexPath.row].id
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}

extension CategoriesAndBrandsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredOrSortedProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        let product = filteredOrSortedProducts[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}

extension CategoriesAndBrandsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 25
        return CGSize(width: width, height: collectionView.frame.width - 120)
    }
}

// MARK: -  Search Bar Delegate Methods

extension CategoriesAndBrandsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        isSearching = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        isSearching = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextSubject.send(searchText.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            searchTextSubject.send(searchText)
        }
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchTextSubject.send("")
    }
}
