//
//  CustomTapBar.swift
//  SportsAppITI
//
//  Created by Engy on 8/11/24.
//

import UIKit


import UIKit

class CustomTapBar: UITabBar {

    @IBOutlet var mainView: UIView!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var customView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        loadNib()
        imageView.animateImageView(imageView: imageView)
        imageView.layer.cornerRadius = 16
        imageView.layer.borderColor = UIColor(named: "#8E8E93")?.cgColor
        imageView.layer.borderWidth = 0.5

    }

    private func loadNib() {
            guard let nib = Bundle.main.loadNibNamed("CustomTapBar", owner: self, options: nil),
                  let mainView = nib.first as? UIView else {return}
            self.mainView = mainView
            addSubview(mainView)
            mainView.frame = self.bounds
            mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sendSubviewToBack(mainView)
        }
}
