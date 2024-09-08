//
//  SettingCell.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import UIKit

class SettingCell: UITableViewCell {
    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        
    }
    
    func config(label: String, imageName: String) {
        settingImage.image = UIImage(named: imageName)
        settingLabel.text = label
    }

}
