//
//  Assesment.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//
import Foundation

class Assesment: Codable{

    var id: String?
    var painScore: Int?
    var painSites: [String: Bool]?
    var questions: [String: Bool]
    var dateAssigned: Date
    var dateCompleted: Date?

    init() {
        self.id = "sample Assesment"
        self.questions = ["Can you wall 5 steps?": false]
        self.dateAssigned = Date()
        self.dateCompleted = Date() + 1
    }
    
    init(id: String, painScore: Int, painSites: [String: Bool], questions: [String: Bool], dateAssigned: Date, dateCompleted: Date) {
        self.id = id
        self.painScore = painScore
        self.painSites = painSites
        self.questions = questions
        self.dateAssigned = dateAssigned
        self.dateCompleted = dateCompleted
    }
}
