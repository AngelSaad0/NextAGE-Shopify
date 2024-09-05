//
//  CategoriesViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import UIKit
import Combine
import Kingfisher

class CategoriesViewController: UIViewController {
    // MARK: -  @IBOutlet
    //comman
    @IBOutlet var searchBar:UISearchBar!
    @IBOutlet var categoryOrBrandCollectionView: UICollectionView!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    //Filtter view fo brand screen
    @IBOutlet var brandFilterView: UIView!
    @IBOutlet var subCategorySegmentControl: UISegmentedControl!
    @IBOutlet var categorySegmentControl: UISegmentedControl!
    
    //SortView view fo catagory screen
    @IBOutlet var sortingOptionsView: UIView!
    @IBOutlet var itemsCountLabel: UILabel!
    @IBOutlet var brandLogoImageView: UIImageView!
    // MARK: -  Properties
    
    //combine
    private var searchTextSubject = PassthroughSubject<String, Never>()
    var itemsCountPublisher = PassthroughSubject<Int, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // General
    var isBrandScreen:Bool = false
    var networkManager: NetworkManager
    var connectivityService: ConnectivityServiceProtocol
    var isFilterApplied: Bool = false
    var searchKeyword: String = ""
    var isSearchingActive: Bool = false
    
    // Selected category and subcategory
    var selectedCategory: String?
    var selectedSubCategory: String?
    
    // Flags and search details
    var isSearchActive: Bool = false
    var searchQuery: String = ""
    var isSearching: Bool = false
    
    // Full product result set and sorting
    var productResults:[Product] = []
    var filteredOrSortedProducts: [Product] = [] {
        didSet {
            itemsCountLabel.text = "\(filteredOrSortedProducts.count) Items"
        }
    }
    
    // Vendor and brand details
    var selectedVendor: String?
    var brandLogoURL: String?
    
    // old
    // Filtered products after search or category filtering
    //var filteredOrSortedProducts: [Product]?
    let offersList = ["6","7","8","9","10","6","7","8","9","10",]
    // var result : Products?
    // var products: [Product]?
    var id:Int?
    
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
    
    @IBAction func sortButtonClicked(_ sender: UIButton) {
        isFilterApplied.toggle()
        filteredOrSortedProducts.sort {
            ((Double($0.variants[0].price) ?? 0.0) > (Double($1.variants[0].price ) ?? 0.0)) == isFilterApplied
        }
        categoryOrBrandCollectionView.reloadData()
    }
    
    func updateUI() {
        categoryOrBrandCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
    }
    func configureUIForCurrentScreen () {
        brandFilterView.isHidden = isBrandScreen
        sortingOptionsView.isHidden = !isBrandScreen
        if isBrandScreen{
            brandLogoImageView.kf.setImage(with:URL(string: brandLogoURL ?? ""),placeholder: UIImage(named: "loading"))
            
        }
        
    }
    
    // MARK: -  private Method
    private func setupSearchTextPublisher() {
        searchTextSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
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
                if  self?.isBrandScreen ?? false {
                    self?.productResults = products.products.filter{$0.vendor == self?.selectedVendor}
                }else{
                    self?.productResults = products.products
                }
                self?.filteredOrSortedProducts = self?.productResults ?? []
                self?.itemsCountPublisher.send(self?.filteredOrSortedProducts.count ?? 0)
                self?.categoryOrBrandCollectionView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        
    }
    private func searchProducts(with searchText:String) {
        if isSearching {
            if searchText.isEmpty {
                filteredOrSortedProducts = productResults
            } else {
                filteredOrSortedProducts = productResults.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            filteredOrSortedProducts = productResults
        }
        updateUIForNoResults()
        categoryOrBrandCollectionView.reloadData()
    }
    
    private func updateUIForNoResults() {
        if (filteredOrSortedProducts.count  == 0) {
            categoryOrBrandCollectionView.displayEmptyMessage("No items found")
        } else {
            categoryOrBrandCollectionView.removeEmptyMessage()
        }
    }
}

extension CategoriesViewController:UICollectionViewDataSource {
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
extension CategoriesViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 2 - 25
        return CGSize(width: width, height: collectionView.frame.width-120)
    }
    
    
}
extension CategoriesViewController:UISearchBarDelegate {
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
            print(searchText)
            
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





