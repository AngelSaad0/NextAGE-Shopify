//
//  OnboardingViewController.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/16/24.
//

import UIKit

class OnboardingViewController: UIViewController{
    
    // MARK: -  outlets for the viewController
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var collectionPageControl: UIPageControl!
    @IBOutlet weak var getStartedButton: UIButton!
    // MARK: -  Properties
    private let viewModel:OnboardingViewModel
    
    // MARK: -  initializer
    required init?(coder: NSCoder) {
        viewModel = OnboardingViewModel()
        super.init(coder: coder)
    }
    // MARK: -  lifeCycle methods for the ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionPageControl.numberOfPages = viewModel.pages.count
    }
    // MARK: -  outlet functions for the viewController
    @IBAction func pageChanged(_ sender: Any) {
        let pc = sender as! UIPageControl
        collectionView.scrollToItem(at: IndexPath(item: pc.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        viewModel.saveToUserDefaults()
        UIWindow.setRootViewController(vcIdentifier: "AuthOptionsNavigationController")
    }
}

// MARK: -  collectionView dataSource & collectionView FlowLayout delegates
extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"OnboardingCollectionViewCell",for: indexPath) as! OnboardingCollectionViewCell
        cell.configureCell(page: viewModel.pages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        collectionPageControl.currentPage = collectionView.indexPathsForVisibleItems[0].item
        if collectionPageControl.currentPage == viewModel.pages.indices.last {
            getStartedButton.setTitle("Get Started", for: .normal)
        } else {
            getStartedButton.setTitle("Skip", for: .normal)
            
        }
        
    }
}
