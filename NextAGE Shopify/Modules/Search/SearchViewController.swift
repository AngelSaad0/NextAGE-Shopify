//
//  SearchViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import UIKit
import Combine
class SearchViewController: UIViewController {
    // MARK: -  IBOutlet
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: -  properties
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var searchKeyword : String = ""
    var isSearching : Bool = false
    var networkManager: NetworkManager
    var connectivityService: ConnectivityServiceProtocol
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //combine
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: -  required init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        connectivityService = ConnectivityService.shared
        super.init(coder: coder)
    }
    // MARK: -  ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        checkInternetConnection()
        setupSearchTextPublisher()
    }
    override func viewWillAppear(_ animated: Bool) {
        productTableView.reloadData()
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
                self?.products = products.products
                self?.filteredProducts = self?.products ?? []
                self?.productTableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        
    }
    private func searchProducts(with searchText:String) {
        if isSearching {
            print(searchText)
            if searchText.isEmpty {
                filteredProducts = products
            } else {
                filteredProducts = products.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            filteredProducts = products
        }
        updateUIForNoResults()
        productTableView.reloadData()
    }
    
    private func updateUIForNoResults() {
        if (filteredProducts.count  == 0) {
            productTableView.displayEmptyMessage("No items found")
        } else {
            productTableView.removeEmptyMessage()
        }
    }
}
// MARK: -  TableViewDataSource
extension SearchViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as! SearchTableCell
        let product = filteredProducts[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    
}
extension SearchViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
#warning("go to product details with info:")
    }
}

extension SearchViewController:UISearchBarDelegate {
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





