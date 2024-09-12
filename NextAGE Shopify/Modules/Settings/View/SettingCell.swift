//
//  SettingCell.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

class SettingCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    // MARK: - Public Methods
    func config(label: String, imageName: String) {
        settingImage.image = UIImage(named: imageName)
        settingLabel.text = label
    }
}
