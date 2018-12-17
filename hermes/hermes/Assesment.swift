//
//  Assesment.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//
import Foundation

class Assesment {

    var painScore: Int
    var sitesOfPain: [String: Bool]
    var questions: [String: Bool]
    var dateAssigned: Date
    var dateCompleted: Date

    init() {
        self.painScore = 0
        self.sitesOfPain = ["Arm": false, "Leg": false, "torso": false]
        self.questions = ["Can you wall 5 steps?": false]
        self.dateAssigned = Date()
        self.dateCompleted = Date() + 1
    }
}
