//
//  HomeViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 02/09/2024.
//

import UIKit
import Combine
class HomeViewController: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet var brandViewForTitle: UIView!
    @IBOutlet private weak var brandBackground: UIImageView!
    @IBOutlet private weak var brandsCollection: UICollectionView!
    @IBOutlet private weak var adsCollectionView: UICollectionView!
    @IBOutlet private weak var adSlideshowPageControl: UIPageControl!
    
    // MARK: - Properties
    private let offersList = ["add1","add2","add3","add4","add5","add6","add7","add8","add9","add10","add11"]
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var networkManager: NetworkManager
    private var connectivityService: ConnectivityServiceProtocol
    private var homeViewModel: HomeViewModel?
    private var brandsResultArray: [SmartCollection] = []
    private var adsArray: [adsModel] = []
    private var loggedIn: Bool?
    private var currentPage = 0
    private var timer: Timer?
    
    // Combine
    private var cancellables = Set<AnyCancellable>()
    private let brandsSubject = PassthroughSubject<[SmartCollection], Never>()
    private let connectivitySubject = PassthroughSubject<Bool, Never>()
    
    // MARK: - Required init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        connectivityService = ConnectivityService.shared
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUIComponents()
        setupBindings()
        updateUI()
    }

 private func updateUI() {
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
        loggedIn = false
#warning("loggedIn = true will change")
        setupActivityIndicator()
        configureAdsPageControl()
        checkInternetConnection()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y + 100)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func configureAdsPageControl() {
        adSlideshowPageControl.numberOfPages = offersList.count
    }
    
    private func checkInternetConnection() {
        connectivityService.checkInternetConnection { [weak self] isConnected in
            self?.connectivitySubject.send(isConnected)
        }
    }
    
    private func loadBrands() {
        networkManager.fetchData(from: ShopifyAPI.smartCollections.shopifyURLString(), responseType: BrandsCollection.self) { [weak self] result in
            guard let brands = result else { return }
            self?.brandsSubject.send(brands.smartCollections)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateAdsScroll), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateAdsScroll() {
        let nextPage = (currentPage < offersList.count - 1) ? currentPage + 1 : 0
        adsCollectionView.scrollToItem(at: IndexPath(item: nextPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func updateBrandsCollectionState() {
        if brandsResultArray.isEmpty {
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
#warning("Perform segue to login")
            }
        )
    }
    
    private func setupBindings() {
        connectivitySubject
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.loadBrands()
                } else {
                    self?.showNoInternetAlert()
                    self?.brandsCollection.displayEmptyMessage("No items found")
                }
            }
            .store(in: &cancellables)
        brandsSubject
            .sink { [weak self] brands in
                self?.brandsResultArray = brands
                self?.updateBrandsCollectionState()
                self?.activityIndicator.stopAnimating()
                self?.brandsCollection.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == adsCollectionView {
            guard let loggedIn = loggedIn, loggedIn else {
                showNotLoggedInAlert()
                return
            }
#warning("let code will change")
            showCouponAlert(code: "code")
        } else if collectionView == brandsCollection {
            let brandsVC = storyboard?.instantiateViewController(identifier: "CategoriesViewController") as! CategoriesViewController
            brandsVC.isBrandScreen = true
            brandsVC.brandLogoURL = brandsResultArray[indexPath.row].image.src
            brandsVC.selectedVendor = brandsResultArray[indexPath.row].title
            navigationController?.pushViewController(brandsVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == adsCollectionView ? offersList.count : brandsResultArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == adsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCollectionCell", for: indexPath) as! AdsCollectionCell
            let image = offersList[indexPath.row]
            cell.configure(with: adsModel(image: image))
            return cell
        } else if collectionView == brandsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionCell", for: indexPath) as! BrandsCollectionCell
            cell.configure(with: brandsResultArray[indexPath.row])
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
