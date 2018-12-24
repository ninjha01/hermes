//
//  Regimen.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//
import Foundation

struct Regimen: Codable {

    var exercises: [Exercise]
    var startDateTime: Date
    var endDateTime: Date
    var progress: Float

    init() {
        self.exercises = [Exercise(), Exercise(), Exercise()]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.startDateTime = dateFormatter.date(from: "2018-12-18")!
        self.endDateTime = dateFormatter.date(from: "2018-12-19")!
        self.progress = 0.00
    }
}
