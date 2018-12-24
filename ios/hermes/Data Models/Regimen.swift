//
//  Regimen.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//
import Foundation

struct Regimen: Codable {
    var id: String
    var title: String
    var exercises: [Exercise]
    var startDateTime: Date
    var endDateTime: Date

    init() {
        self.id = "sampleRegimenID"
        self.title = "Test"
        self.exercises = [Exercise(), Exercise(), Exercise()]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.startDateTime = dateFormatter.date(from: "2018-12-18")!
        self.endDateTime = dateFormatter.date(from: "2018-12-19")!
    }
    
    init(id: String, title: String, exercises: [Exercise], startDateTime: Date, endDateTime: Date) {
        self.id = id
        self.title = title
        self.exercises = exercises
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
    }
}
