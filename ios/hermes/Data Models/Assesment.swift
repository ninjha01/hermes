//
//  Assesment.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//
import Foundation

class Assesment: Codable{

    var key: String?
    var title: String?
    var painScore: Int?
    var painSites: [String: Bool] = [:]
    var questions: [String: Bool] = [:]
    var dateAssigned: Date
    var dateCompleted: Date?

    init() {
        self.key = "sample key"
        self.title = "Sample Test"
        self.painScore = -1
        self.dateAssigned = Date()    }
    
    init(id: String, painScore: Int, painSites: [String: Bool], questions: [String: Bool], dateAssigned: Date, dateCompleted: Date) {
        self.key = id
        self.painScore = painScore
        self.painSites = painSites
        self.questions = questions
        self.dateAssigned = dateAssigned
        self.dateCompleted = dateCompleted
    }
}
