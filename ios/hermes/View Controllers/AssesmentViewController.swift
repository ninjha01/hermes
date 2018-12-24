//
//  AssesmentViewController.swift
//  hermes
//
//  Created by Nishant Jha on 12/21/18.
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit
import DLRadioButton
import FirebaseAuth

class AssesmentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //TODO refactor to use this field or remove
    var assesment: Assesment = Assesment()
    let painScoreData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var painSiteButtons: [DLRadioButton] = []
    var questionButtons: [DLRadioButton] = []
    
    var dateFormatter: DateFormatter {
        let x = DateFormatter()
        x.dateFormat = "yyyy-MM-dd"
        return x
    }
    
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
        for site in self.assesment.painSites {
            //Build question
            let radioButton = DLRadioButton()
            radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 18)
            let color: UIColor = .blue
            radioButton.setTitleColor(color, for: []);
            radioButton.iconColor = color;
            radioButton.indicatorColor = color;
            radioButton.setTitle(site.key, for: [])
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
        for question in self.assesment.questions {
            //Build question
            let radioButton = DLRadioButton()
            radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 18)
            let color: UIColor = .blue
            radioButton.setTitleColor(color, for: []);
            radioButton.iconColor = color;
            radioButton.indicatorColor = color;
            radioButton.setTitle(question.key, for: [])
            radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            radioButton.isIconSquare = true
            radioButton.isIconOnRight = false
            radioButton.titleLabel?.lineBreakMode = .byWordWrapping
            questionButtons.append(radioButton)
            self.questionsButtonStack.addArrangedSubview(radioButton)
        }
        let firstButton = questionButtons[0]
        firstButton.otherButtons =  Array(questionButtons.dropFirst())
        firstButton.isMultipleSelectionEnabled = true
        self.questionsButtonStack.sizeToFit()
        self.questionsButtonStack.setNeedsDisplay()
    }
    
    func initSubmitButtion() {
        
    }
    
    @IBAction func logResults(_ sender: Any) {
        let selectedPainButtons = self.painSiteButtons[0].selectedButtons()
        var painSites : [String: Bool] = [:]
        for button in selectedPainButtons {
            painSites[button.title(for: [])!] = true
        }
        var questions: [String: Bool] = [:]
        for button in questionButtons {
            if button.isSelected {
               questions[button.title(for: [])!] = true
            } else {
                questions[button.title(for: [])!] = false
            }
        }
        let today = Date()
        let todayString = dateFormatter.string(from: today)
        let dateAssignedString = dateFormatter.string(from: self.assesment.dateAssigned)
        let userDocument = appDelegate.ref!.child("users").child(Auth.auth().currentUser!.uid)
        let newAssesmentNode = userDocument.child("assesments").childByAutoId()
        newAssesmentNode.setValue(["key": self.assesment.key!, "painScore": self.assesment.painScore!, "painSites": self.assesment.painSites, "questions": self.assesment.questions, "dateAssigned": dateAssignedString, "dateCompleted": todayString])
        
        //Return to Calendar
        self.navigationController?.popViewController(animated: true)
    }
    
    func parseAPSForAssesment(aps: [String: AnyObject]) {
        self.assesment.key = aps["key"] as? String
        self.assesment.title = aps["title"] as? String
        for site in aps["painSites"] as! [String] {
            self.assesment.painSites[site] = false
        }
        for question in aps["questions"] as! [String] {
            self.assesment.questions[question] = false
        }
        self.assesment.dateAssigned = dateFormatter.date(from: aps["dateAssigned"] as! String)!
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
        self.assesment.painScore = painScoreData[row]
    }
}
