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
    @IBOutlet var sizeDropdownTableView: UITableView!
    @IBOutlet var viewAllReviewsButton: UIButton!
    @IBOutlet var addToChartButton: UIButton!
    @IBOutlet var colorDropdownTableView: UITableView!
    private var isSizeDropdownVisible = false
    private var isColorDropdownVisible = false
    private var selectedButton: UIButton?
    private let selectedButtonColor = UIColor.red
    private var productSize: [String] = []
    private var dropdownColor: [String] = []
    // MARK: - Properties
    let indicator = UIActivityIndicatorView(style: .large)
    let networkManager: NetworkManager
    var productID: Int?
    var product: ProductInfo?

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
        setupIndicator()
        fetchProduct()
    }

    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        super.init(coder: coder)
    }

    // MARK: - Private Methods
    private func UpdateUI() {
        title = "NextAGE"
        sizeDropdownTableView.isHidden = true
        colorDropdownTableView.isHidden = true
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
        productDescriptionTextView.text = product?.bodyHTML
        reviewTableView.reloadData()
        productCollectionView.reloadData()
        updateDropdownOptions()
    }

    private func updateDropdownOptions() {
        var sizeOptions: [String] = []
        var colorOptions: [String] = []
        for option in product?.options ?? [] {
            if option.name == .size {
                sizeOptions = option.values
            } else if option.name == .color {
                colorOptions = option.values
            }
        }
        productSize = sizeOptions
        dropdownColor = colorOptions
        sizeDropdownTableView.reloadData()
        colorDropdownTableView.reloadData()

        if let firstSize = productSize.first {
            productSizeButton.setTitle(firstSize, for: .normal)
            productSizeButton.backgroundColor = .blue

        }

        if let firstColor = dropdownColor.first {
            productColorButton.setTitle(firstColor, for: .normal)
            productColorButton.backgroundColor = .blue

        }
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

    private func toggleSizeDropdown() {
        if isSizeDropdownVisible {
            sizeDropdownTableView.isHidden = true
            isSizeDropdownVisible = false
        } else {
            sizeDropdownTableView.reloadData()
            if let button = selectedButton {
                sizeDropdownTableView.isHidden = false
                isSizeDropdownVisible = true
            }
        }
    }

    private func toggleColorDropdown() {
        if isColorDropdownVisible {
            colorDropdownTableView.isHidden = true
            isColorDropdownVisible = false
        } else {
            colorDropdownTableView.reloadData()
            if let button = selectedButton {
                colorDropdownTableView.isHidden = false
                isColorDropdownVisible = true
            }
        }
    }

    @IBAction func productSizeButtonClicked(_ sender: UIButton) {
        selectedButton = sender
        toggleSizeDropdown()
    }

    @IBAction func productColorButtonClicked(_ sender: UIButton) {
        selectedButton = sender
        toggleColorDropdown()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: product!.images[indexPath.row].src))
        return cell
    }
}

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sizeDropdownTableView {
            return productSize.count
        } else if tableView == colorDropdownTableView {
            return dropdownColor.count
        } else if tableView == reviewTableView {
            return product == nil ? 0 : 2
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sizeDropdownTableView || tableView == colorDropdownTableView {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            if tableView == sizeDropdownTableView {
                cell.textLabel?.text = productSize[indexPath.row]
            } else if tableView == colorDropdownTableView {
                cell.textLabel?.text = dropdownColor[indexPath.row]
            }
            return cell
        } else if tableView == reviewTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sizeDropdownTableView {
            productSizeButton.setTitle(productSize[indexPath.row], for: .normal)
            toggleSizeDropdown()
        } else if tableView == colorDropdownTableView {
            productColorButton.setTitle(dropdownColor[indexPath.row], for: .normal)
            toggleColorDropdown()
        } else if tableView == reviewTableView {
            pushViewController(vcIdentifier: "AllReviewsViewController", withNav: navigationController)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == reviewTableView {
            return 110
        }
        return UITableView.automaticDimension
    }
}
