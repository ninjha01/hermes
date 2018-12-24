//
//  Exercise.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit

struct Exercise: Codable {
    var id: String
    var title: String
    var instructions: String
    var startDateTime: Date
    var endDateTime: Date
    var completed: Bool
    var primaryVideoFilename: String
    var secondaryMultimediaFilenames: [String]
    var sets: Int
    var reps: Int
    var intensity: String
    var equipment: String

    init() {
        self.id = "sample Exercise"
        self.title = ["Leg Raises", "Planking", "Squats", "Pushups", "Burpees", "Leg Press", "Bicep Curls", "Jumping Jacks", "High Knees"].randomElement()!
        self.instructions = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        let day = [Int](0...27).randomElement()!
        let hour = [Int](0...23).randomElement()!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.startDateTime = Calendar.current.date(byAdding: .day, value: day, to: dateFormatter.date(from: "2018-12-01")!)!
        self.endDateTime = Calendar.current.date(byAdding: .hour, value: hour, to: startDateTime)!
        self.completed = [true, false].randomElement()!
        self.primaryVideoFilename = "output"
        self.secondaryMultimediaFilenames = [["secondary"], []].randomElement()!
        self.sets = [1,2,3,4,5,6,7,8,9,10].randomElement()!
        self.reps = [1,2,3,4,5,6,7,8,9,10].randomElement()!
        self.intensity = ["High", "Medium", "Low"].randomElement()!
        self.equipment = ["None", "Barbells", "Yoga Mat", "Foam Roller"].randomElement()!
    }
    
    init(id: String, title: String, instructions: String, startDateTime: Date, endDateTime: Date, completed: Bool, primaryVideoFilename: String, secondaryMultimediaFilenames: [String], sets: Int, reps: Int, intensity: String, equipment: String) {
        self.id = id
        self.title = title
        self.instructions = instructions
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.completed = completed
        self.primaryVideoFilename = primaryVideoFilename
        self.secondaryMultimediaFilenames = secondaryMultimediaFilenames
        self.sets = sets
        self.reps = reps
        self.intensity = intensity
        self.equipment = equipment
    }

    static func ==(lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.startDateTime == rhs.startDateTime
    }

    static func <(lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.startDateTime < rhs.startDateTime
    }
    
    public var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.string(from: self.startDateTime)
        let endDate = dateFormatter.string(from: self.endDateTime)
        return self.title + ", " + self.instructions + ", "
          + startDate + ", " + endDate
    }
}
