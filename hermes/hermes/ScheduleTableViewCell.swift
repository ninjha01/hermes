//
//  ScheduleTableViewCell.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLine: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    var exercise: Exercise! {
        didSet {
            titleLabel.text = exercise.title
            noteLabel.text = exercise.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            startTimeLabel.text = dateFormatter.string(from: exercise.startDateTime)
            endTimeLabel.text = dateFormatter.string(from: exercise.endDateTime)
            if exercise.completed {
                categoryLine.backgroundColor = .green
            } else {
                categoryLine.backgroundColor = .red
            }
        }
    }
}
