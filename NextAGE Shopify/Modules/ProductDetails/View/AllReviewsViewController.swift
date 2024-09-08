//
//  AllReviewsViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import UIKit

class AllReviewsViewController: UIViewController {
    @IBOutlet weak var allReviewsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return dummyReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.configure(with: dummyReviews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
