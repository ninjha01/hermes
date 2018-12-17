//
//  ExerciseViewController.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/18.
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ExerciseViewController: UIViewController {
    
    @IBOutlet weak var videoViewContainer: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private var player: AVQueuePlayer?
    var exercise: Exercise = Exercise()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initPrimaryVideo()
        initDescription()
        initSecondaryMultimedia()
    }
    
    func initPrimaryVideo() {
        let mp4Name = self.exercise.primaryVideoFilename
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
    
    func initDescription() {
        self.descriptionTextView.text = self.exercise.description
    }
    func initSecondaryMultimedia() {
        debugPrint("No secondary media")
    }
}
