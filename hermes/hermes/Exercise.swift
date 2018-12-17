//
//  Exercise.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit

class Exercise {
    var title: String
    var description: String
    var startDateTime: Date
    var endDateTime: Date
    var completed: Bool
    var equipment: String
    var primaryVideoFilename: String
    var secondaryMultimediaFilenames: [String]

    init() {
        self.title = "Leg Raises"
        self.description = "Raise your legs"
        self.startDateTime = Date()
        self.endDateTime = Date() + 1
        self.completed = false
        self.equipment = ""
        self.primaryVideoFilename = "output"
        self.secondaryMultimediaFilenames = []
    }    

    static func ==(lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.startDateTime == rhs.startDateTime
    }

    static func <(lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.startDateTime < rhs.startDateTime
    }
}
