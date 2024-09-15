//
//  CategoriesAndBrandsViewModel.swift
//  NextAGE Shopify
//
//  Created by Engy on 08/09/2024.
//
class CategoriesAndBrandsViewModel {
    
    // MARK: - Properties
    var isBrandScreen: Bool = false
    var isSearching: Bool = false
    var isFilterApplied: Bool = false
    var isSearchActive: Bool = false
    var searchKeyword: String = ""
    var selectedCategory: String?
    var selectedSubCategory: String?
    var selectedVendor: String?
    var brandLogoURL: String?
    private let networkManager: NetworkManagerProtocol
    let connectivityService: ConnectivityServiceProtocol
    var productResults: [Product] = []
    var filteredOrSortedProducts: [Product] = [] {
        didSet {
            updateItemsCount("\(filteredOrSortedProducts.count) Items")
            updateUIForNoResults()
            bindResultTable()
        }
    }
    var bindResultTable:(()->()) = {}
    var setIndicator:((Bool)->()) = {_ in}
    var displayEmptyMessage:((String)->()) = {_ in}
    var removeEmptyMessage:(()->()) = {}
    var updateItemsCount:((String)->()) = {_ in}
    
    // MARK: -  init
    init() {
        networkManager = NetworkManager.shared
        connectivityService = ConnectivityService.shared
    }
    
    // MARK: -  Public Method
    func filterResults(category: String = "All", subCategory: String = "All") {
        var filteredResults = productResults
        switch category {
        case "Women":
            filteredResults = filteredResults.filter { $0.tags.contains("women") }
        case "Men":
            filteredResults = filteredResults.filter { $0.tags.contains("men") && !$0.tags.contains("women") }
        case "Kids":
            filteredResults = filteredResults.filter { $0.tags.contains("kids") }
        default:
            filteredResults = productResults
        }
        
        if subCategory == "Accessories" || subCategory == "T-Shirts" || subCategory == "Shoes" {
            filteredResults = filteredResults.filter { $0.productType.rawValue == subCategory.uppercased() }
        }
        
        if !searchKeyword.isEmpty {
            filteredResults = filteredResults.filter { $0.title.lowercased().contains(searchKeyword.lowercased()) }
        }
        
        filteredOrSortedProducts = filteredResults
    }
    
    func applyFiltersAndSearch() {
        filterResults(category: selectedCategory ?? "All", subCategory: selectedSubCategory ?? "All")
    }
    
    func updateUIForNoResults() {
        if filteredOrSortedProducts.isEmpty {
            self.displayEmptyMessage("No Items In Stock")
        } else {
            self.removeEmptyMessage()
        }
    }
    func loadProducts() {
        networkManager.fetchData(from: ShopifyAPI.products.shopifyURLString(), responseType: Products.self, headers: []) { result in
            guard let products = result else { return }
            if self.isBrandScreen  {
                self.productResults = products.products.filter { $0.vendor == self.selectedVendor }
            } else {
                self.productResults = products.products
            }
            self.filteredOrSortedProducts = self.productResults
            self.bindResultTable()
            self.setIndicator(false)
        }
    }
    func searchProducts(with searchText: String) {
        searchKeyword = searchText
        applyFiltersAndSearch()
    }
    
    
}
