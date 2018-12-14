//
//  ViewController.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/18.
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var videoViewContainer: UIView!
    private var player: AVQueuePlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playVideo() 
    }

    
    func playVideo() {
        
        let mp4Name = "output"
        let mp4URL = Bundle.main.url(forResource: mp4Name, withExtension: "mp4")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: mp4URL!.absoluteString) {
            print("FILE AVAILABLE")
        } else {
            print("FILE NOT AVAILABLE")
        }
        
        // initialize the video player with the url
        self.player = AVQueuePlayer(url: mp4URL!)
        
        // create a video layer for the player
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        
        // make the layer the same size as the container view
        layer.frame = videoViewContainer.bounds
        
        // make the video fill the layer as much as possible while keeping its aspect size
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        // add the layer to the container view
        videoViewContainer.layer.addSublayer(layer)
        self.player!.play()
    }
}

