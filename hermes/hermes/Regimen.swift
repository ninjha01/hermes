//
//  Regimen.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//
import Foundation

class Regimen {

    var exercises: [Exercise]
    var startDateTime: Date
    var endDateTime: Date
    var progress: Float

    init() {
        self.exercises = [Exercise(), Exercise(), Exercise()]
        self.startDateTime = Date()
        self.endDateTime = Date() + 1
        self.progress = 0.00
    }
}
