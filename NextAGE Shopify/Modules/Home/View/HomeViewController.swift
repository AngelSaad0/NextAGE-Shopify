//
//  HomeViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 02/09/2024.
//

import UIKit

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet var brandViewForTitle: UIView!
    @IBOutlet private weak var brandBackground: UIImageView!
    @IBOutlet private weak var brandsCollection: UICollectionView!
    @IBOutlet private weak var adsCollectionView: UICollectionView!
    @IBOutlet private weak var adSlideshowPageControl: UIPageControl!
    
    // MARK: - Properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var viewModel: HomeViewModel
    private var currentPage = 0
    private var timer: Timer?
    
    // MARK: - Required init
    required init?(coder: NSCoder) {
        viewModel = HomeViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUIComponents()
        updateUI()
        checkInternetConnection()
    }
    
    private func updateUI() {
        tabBarController?.navigationItem.title = "NextAGE"
        brandViewForTitle.addRoundedRadius(radius: 8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    // MARK: - Private Methods
    private func initializeUIComponents() {
        setupActivityIndicator()
        configureAdsPageControl()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y + 100)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func configureAdsPageControl() {
        adSlideshowPageControl.numberOfPages = viewModel.offersList.count
    }
    
    private func checkInternetConnection() {
        viewModel.checkInternetConnection { [weak self] isConnected in
            DispatchQueue.main.async {
                if isConnected {
                    self?.loadBrands()
                    self?.loadPriceRules()
                } else {
                    self?.showNoInternetAlert()
                    self?.brandsCollection.displayEmptyMessage("No items found")
                }
            }
        }
    }
    
    private func loadBrands() {
        viewModel.loadBrands { [weak self] in
            DispatchQueue.main.async {
                self?.updateBrandsCollectionState()
                self?.activityIndicator.stopAnimating()
                self?.brandsCollection.reloadData()
            }
        }
    }

    private func loadPriceRules() {
        viewModel.loadPriceRules { [weak self] in
            DispatchQueue.main.async {
                self?.adsCollectionView.reloadData()
                self?.configureAdsPageControl()

            }
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateAdsScroll), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateAdsScroll() {
        let nextPage = (currentPage < viewModel.offersList.count - 1) ? currentPage + 1 : 0
        adsCollectionView.scrollToItem(at: IndexPath(item: nextPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func updateBrandsCollectionState() {
        if viewModel.brandsResultArray.isEmpty {
            brandsCollection.displayEmptyMessage("No Items Found")
        } else {
            brandsCollection.removeEmptyMessage()
        }
    }
    
    private func showCouponAlert(code: String) {
        showAlert(
            title: "Congratulations",
            message: "Click Copy to get your coupon",
            okTitle: "Copy",
            okHandler: { _ in
                UIPasteboard.general.string = code
            }
        )
    }
    
    private func showNotLoggedInAlert() {
        showAlert(
            title: "Not Logged In",
            message: "Please log in to access the coupon.",
            okTitle: "Login",
            cancelTitle: "Cancel",
            okHandler: { _ in
                self.pushViewController(vcIdentifier: "SignInViewController", withNav: self.navigationController)
            }
        )
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == adsCollectionView {
            guard viewModel.isLoggedIn else {
                showNotLoggedInAlert()
                return
            }
            if viewModel.discountCodes.indices.contains(indexPath.row) {
                showCouponAlert(code: viewModel.discountCodes[indexPath.row])
            } else {
                showAlert(title: "Still loading", message: "Please wait while discount code loads")
            }
        } else if collectionView == brandsCollection {
            let brandsVC = storyboard?.instantiateViewController(identifier: "CategoriesAndBrandsViewController") as! CategoriesAndBrandsViewController
            brandsVC.viewModel.isBrandScreen = true
            brandsVC.viewModel.brandLogoURL = viewModel.brandsResultArray[indexPath.row].image.src
            brandsVC.viewModel.selectedVendor = viewModel.brandsResultArray[indexPath.row].title
            navigationController?.pushViewController(brandsVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == adsCollectionView ? viewModel.offersList.count : viewModel.brandsResultArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == adsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionCell", for: indexPath)
            let image = viewModel.offersList[indexPath.row]
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = UIImage(named: image)
            imageView.addCornerRadius(radius: 10)
            return cell
        } else if collectionView == brandsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionCell", for: indexPath) as! BrandCollectionCell
            cell.configure(with: viewModel.brandsResultArray[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == adsCollectionView ? adsItemSize(for: collectionView) : brandsItemSize(for: collectionView)
    }
    
    private func adsItemSize(for collectionView: UICollectionView) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    private func brandsItemSize(for collectionView: UICollectionView) -> CGSize {
        let numberOfCellsPerRow: CGFloat = 2
        let collectionViewWidth = collectionView.bounds.width
        let adjustedWidth = (collectionViewWidth - 60) / numberOfCellsPerRow
        return CGSize(width: adjustedWidth, height: adjustedWidth)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == adsCollectionView {
            currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
            adSlideshowPageControl.currentPage = currentPage
        }
    }
}
