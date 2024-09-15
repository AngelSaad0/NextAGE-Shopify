//
//  AllReviewsViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import UIKit

class AllReviewsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var allReviewsTableView: UITableView!
    
    // MARK: - Properties
    let viewModel: AllReviewsViewModel
    
    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = AllReviewsViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        title = "All Reviews"
        allReviewsTableView.delegate = self
        allReviewsTableView.dataSource = self
        allReviewsTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
    }
}

extension AllReviewsViewController: UITableViewDelegate {
    
}

extension AllReviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getReviewsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.configure(with: viewModel.getReview(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
