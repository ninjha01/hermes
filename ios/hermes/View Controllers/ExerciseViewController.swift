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
    
    @IBOutlet weak var secondaryMediaView: UIView!
    @IBOutlet weak var videoViewContainer: UIView!
    @IBOutlet weak var doneButton: UIButton!

    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var setTextView: UITextView!
    @IBOutlet weak var repsTextView: UITextView!
    @IBOutlet weak var intensityTextView: UITextView!
    @IBOutlet weak var equipmentTextView: UITextView!
    
    var delegate: CalendarViewController?
    
    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async() { //UI Thread
            self.initNavbar()
            self.initPrimaryVideo()
            self.initSecondaryMultimedia()
            self.initTextViews()
            self.initDoneButton()
            self.initSecondaryMultimedia()
        }
    }
    
    func initNavbar() {
        self.navigationController!.navigationBar.topItem?.title = self.exercise?.title
    }
    
    func initPrimaryVideo() {
        let mp4Name = self.exercise!.primaryVideoFilename
        let mp4URL = Bundle.main.url(forResource: mp4Name, withExtension: "mp4")
        
        // initialize the video player with the url
        self.player = AVQueuePlayer(url: mp4URL!)
        looper = AVPlayerLooper(player: self.player!, templateItem: AVPlayerItem(asset: AVAsset(url: mp4URL!)))
        
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
    
    func initTextViews() {
        self.descriptionTextView.text = self.exercise!.instructions
        self.descriptionTextView.sizeToFit()

        self.setTextView.text = String (self.exercise!.sets)
          self.repsTextView.text = String (self.exercise!.reps)
          self.intensityTextView.text = self.exercise!.intensity
          self.equipmentTextView.text = self.exercise!.equipment
    }
    func initSecondaryMultimedia() {
        if self.exercise!.secondaryMultimediaFilenames.count > 0 {
            self.secondaryMediaView.isHidden = false
            let filename = self.exercise!.secondaryMultimediaFilenames[0]
            self.secondaryMediaView.backgroundColor = UIColor(patternImage: UIImage(named: filename)!)
        } else {
            self.secondaryMediaView.isHidden = true
        }
    }
    
    func initDoneButton() {
        doneButton.isEnabled = !exercise!.completed
    }
    
    @IBAction func markExerciseDone(_ sender: Any) {
        self.exercise!.completed = true
        doneButton.isEnabled = false
        delegate!.getExercise()
    }
}
