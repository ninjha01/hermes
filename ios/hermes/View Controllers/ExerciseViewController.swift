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

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var secondaryMediaView: UIView!
    @IBOutlet weak var videoViewContainer: UIView!
    @IBOutlet weak var doneButton: UIButton!

    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var setTextView: UITextView!
    @IBOutlet weak var repsTextView: UITextView!
    @IBOutlet weak var equipmentTextView: UITextView!
    
    var delegate: CalendarViewController?
    
    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    private var avpController: AVPlayerViewController?
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async() { //UI Thread
            self.initNavbar()
            self.initSecondaryMultimedia()
            self.initTextViews()
            self.initDoneButton()
            self.initSecondaryMultimedia()
            self.initPrimaryVideo()
        }
    }
    
    func initNavbar() {
        self.navigationController!.navigationBar.topItem?.title = self.exercise?.title
    }
    
    func initPrimaryVideo() {
        let mp4Name = self.exercise!.primaryVideoUrl
        debugPrint(mp4Name)
        let mp4URL = URL(string: mp4Name)
        
        // initialize the video player with the url
        self.player = AVQueuePlayer(url: mp4URL!)
        looper = AVPlayerLooper(player: self.player!, templateItem: AVPlayerItem(asset: AVAsset(url: mp4URL!)))
        
        // add the layer to the container view
        self.avpController = AVPlayerViewController()
        self.avpController!.player = self.player
        avpController!.view.frame = videoViewContainer.bounds
        self.addChild(avpController!)
        videoViewContainer.addSubview(self.avpController!.view)
        self.player!.play()
    }
    
    func initTextViews() {
        self.descriptionTextView.text = self.exercise!.instructions
        self.descriptionTextView.sizeToFit()

        self.setTextView.text = String (self.exercise!.sets)
          self.repsTextView.text = String (self.exercise!.reps)
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
    
    func updateExerciseByKey(key: String, valueDict: [String: AnyObject]) {
        let userDocument = appDelegate.getUserDocument()
        if (userDocument != nil) {
            userDocument!.child("exerciseData").child(key).updateChildValues(["completed": true])
        } else {
            print("Failed to update exercise by key", key, valueDict)
        }
    }
    
    @IBAction func markExerciseDone(_ sender: Any) {
        self.exercise!.completed = true
        delegate!.currentExercise?.completed = true
        doneButton.isEnabled = false
        self.updateExerciseByKey(key: self.exercise!.key, valueDict: ["completed": true] as [String: AnyObject])
    }
}
