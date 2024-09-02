//
//  AuthOptionsViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 02/09/2024.
//

import UIKit
import AVFoundation
class AuthOptionsViewController: UIViewController {

    @IBOutlet var skipBtn: UIBarButtonItem!
    @IBOutlet var singUpBtn: UIButton!
    
    @IBOutlet var vedioLayerView: UIView!
    @IBOutlet var longInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = skipBtn
        playVedio()
    }
    
    func playVedio() {
        guard let  path = Bundle.main.path(forResource: "intro", ofType: "mp4") else {
            print(Bundle.main.bundlePath)
            print("no vedio")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.vedioLayerView.layer.addSublayer(playerLayer)
        self.view.insertSubview(vedioLayerView, at: 0)

        player.play()
   
        
    }

}
