//
//  CurrencyViewController.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

class CurrencyViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var currencyTableView: UITableView!
    
    // MARK: - Properties
    let viewModel: CurrencyViewModel
    let indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = CurrencyViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        title = "Currency"
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        setupIndicator()
    }
    
    private func setupIndicator() {
        indicator.center = view.center
        view.addSubview(indicator)
    }
    
    private func setupViewModel() {
        viewModel.popView = {
            self.navigationController?.popViewController(animated: true)
        }
        viewModel.displayMessage = { massage, isError in
            displayMessage(massage: massage, isError: isError)
        }
        viewModel.setIndicator = { state in
            DispatchQueue.main.async { [weak self] in
                state ? self?.indicator.startAnimating() : self?.indicator.stopAnimating()
            }
        }
    }
}

extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        viewModel.currencyDidSelect(at: indexPath.row)
    }
}

extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCurrenciesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = viewModel.getCurrencyLabel(at: indexPath.row)
        if viewModel.isCurrentCurrency(at: indexPath.row) {
            cell.viewWithTag(2)?.isHidden = false
        }
        cell.viewWithTag(3)?.addCornerRadius(radius: 12)
        cell.viewWithTag(3)?.addBorderView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
