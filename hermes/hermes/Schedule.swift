//
//  Schedule.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit

struct Schedule {
    var title: String
    var note: String
    var startTime: Date
    var endTime: Date
    var categoryColor: UIColor
}

// random events
extension Schedule {
    init(fromStartDate: Date) {
        title = ["Meet Willard", "Buy a milk", "Read a book"].randomElement()!
        note = ["hurry", "In office", "In New york city"].randomElement()!
        categoryColor = [.red, .orange, .purple, .blue, .black].randomElement()!
        
        let day = [Int](0...27).randomElement()!
        let hour = [Int](0...23).randomElement()!
        let startDate = Calendar.current.date(byAdding: .day, value: day, to: fromStartDate)!
        
        
        startTime = Calendar.current.date(byAdding: .hour, value: hour, to: startDate)!
        endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime)!
    }
}


extension Schedule : Equatable {
    static func ==(lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.startTime == rhs.startTime
    }
}

extension Schedule : Comparable {
    static func <(lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.startTime < rhs.startTime
    }
}
