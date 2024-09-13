//
//  SearchViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    // MARK: - Properties

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var viewModel : SearchViewModel

    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = SearchViewModel()
        super.init(coder: coder)
    }

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupViewModel()
        viewModel.checkInternetConnection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productTableView.reloadData()
    }

    // MARK: - Private Methods
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }

    private func setupViewModel(){
        viewModel.activityIndicator = { state in
            DispatchQueue.main.async {[weak self] in
                state ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }

        }
        viewModel.showNoInternetAlert = {
            self.showNoInternetAlert()
        }
        viewModel.bindTablView = {
            DispatchQueue.main.async {[weak self] in
                self?.productTableView.reloadData()
            }
        }
        viewModel.displayEmptyMessage = { message in
            self.productTableView.displayEmptyMessage(message)

        }
        viewModel.removeEmptyMessage = {
            self.productTableView.removeEmptyMessage()
        }

    }

}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as! SearchTableCell
        let product = viewModel.filteredProducts[indexPath.row]
        cell.configure(with: product)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredProducts.count
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsViewController.viewModel.productID = viewModel.filteredProducts[indexPath.row].id
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
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
