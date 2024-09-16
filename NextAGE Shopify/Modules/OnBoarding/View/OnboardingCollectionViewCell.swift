//
//  OnboardingCollectionViewCell.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/16/24.
//

import UIKit
import Lottie

struct Page {
    let animationName: String
    let title: String
    let description: String
}

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    private var animationView: LottieAnimationView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        animationViewContainer()
    }

   private func animationViewContainer() {
        animationView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 0.8)

    }

    func configureCell(page: Page) {
        animationView?.removeFromSuperview()
        animationView = nil
        animationView = LottieAnimationView(name: page.animationName)
        animationViewContainer()
        animationView?.animationSpeed = 1
        animationView?.loopMode = .loop
        animationView?.play()
        if let animationView = animationView {
            animationContainer.addSubview(animationView)
        }
        self.titleLabel.text = page.title
        self.descriptionTextView.text = page.description
    }
}
