//
//  AssesmentViewController.swift
//  hermes
//
//  Created by Nishant Jha on 12/21/18.
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit
import DLRadioButton

class AssesmentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //TODO refactor to use this field or remove
    var assesment: Assesment?
    var painScore: Int = -1
    let painScoreData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var painSites: [String]?
    var painSiteButtons: [DLRadioButton] = []
    var trueFalseQuestions: [String]?
    var trueFalseQuestionButtons: [DLRadioButton] = []
    
    @IBOutlet weak var painScoreLabel: UILabel!
    @IBOutlet weak var painScorePicker: UIPickerView!
    @IBOutlet weak var painSitesLabel: UILabel!
    @IBOutlet weak var painSiteButtonsStack: UIStackView!
    @IBOutlet weak var questionsButtonStack: UIStackView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async() { //UI Thread
            self.initNavbar()
            self.initPicker()
            self.initPainSitesStack()
            self.initQuestionsStack()
            self.initSubmitButtion()
        }
    }
    
    func initNavbar() {
        self.navigationController!.navigationBar.topItem?.title = self.title
    }
    
    func initPicker() {
        self.painScorePicker.delegate = self
        self.painScorePicker.dataSource = self
    }
    
    func initPainSitesStack() {
        self.painSiteButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        for site in self.painSites! {
            //Build question
            let radioButton = DLRadioButton()
            radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 18)
            let color: UIColor = .blue
            radioButton.setTitleColor(color, for: []);
            radioButton.iconColor = color;
            radioButton.indicatorColor = color;
            radioButton.setTitle(site, for: [])
            radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            painSiteButtons.append(radioButton)
            self.painSiteButtonsStack.addArrangedSubview(radioButton)
        }
        let firstButton = painSiteButtons[0]
        firstButton.otherButtons =  Array(painSiteButtons.dropFirst())
        firstButton.isMultipleSelectionEnabled = true
        self.painSiteButtonsStack.sizeToFit()
        self.painSiteButtonsStack.setNeedsDisplay()
    }
    
    func initQuestionsStack() {
        self.questionsButtonStack.translatesAutoresizingMaskIntoConstraints = false
        for question in self.trueFalseQuestions! {
            //Build question
            let radioButton = DLRadioButton()
            radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 18)
            let color: UIColor = .blue
            radioButton.setTitleColor(color, for: []);
            radioButton.iconColor = color;
            radioButton.indicatorColor = color;
            radioButton.setTitle(question, for: [])
            radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            radioButton.isIconSquare = true
            radioButton.isIconOnRight = false
            radioButton.titleLabel?.lineBreakMode = .byWordWrapping
            trueFalseQuestionButtons.append(radioButton)
            self.questionsButtonStack.addArrangedSubview(radioButton)
        }
        let firstButton = trueFalseQuestionButtons[0]
        firstButton.otherButtons =  Array(trueFalseQuestionButtons.dropFirst())
        firstButton.isMultipleSelectionEnabled = true
        self.questionsButtonStack.sizeToFit()
        self.questionsButtonStack.setNeedsDisplay()
    }
    
    func initSubmitButtion() {
        
    }
    
    @IBAction func logResults(_ sender: Any) {
        debugPrint("Pain Score: " + String(self.painScore))
        
        let selectedPainButtons = self.painSiteButtons[0].selectedButtons()
        var painSites = ""
        for button in selectedPainButtons {
            painSites += button.title(for: [])! + " "
        }
        debugPrint("Pain Sites: " + painSites)
        
        var questions = ""
        for button in trueFalseQuestionButtons {
            questions += button.title(for: [])! + " : "
            if button.isSelected {
                questions += "Yes | "
            } else {
                questions += "No | "
            }
        }
        debugPrint("Questions: " + questions)
        //Return to Calendar
        self.navigationController?.popViewController(animated: true)
    }
    
    func parseAPSForAssesment(aps: [String: AnyObject]) {
        self.title = aps["title"] as? String
        self.painSites = aps["painSites"] as? [String]
        self.trueFalseQuestions = aps["trueFalseQuestions"] as? [String]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.painScorePicker {
            return painScoreData.count
        }
        return -1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.painScorePicker {
            return "\(painScoreData[row])"
        }
        return "Something went wrong"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.painScore = painScoreData[row]
    }
}
