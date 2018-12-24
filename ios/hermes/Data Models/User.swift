//
//  User.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

class User {
    var currentRegimens: [Regimen]
    var pastRegimens: [Regimen]
    var assesments: [Assesment]

    init() {
        self.currentRegimens = [Regimen(), Regimen(), Regimen()]
        self.pastRegimens = [Regimen(), Regimen(), Regimen()]
        self.assesments = [Assesment(), Assesment(), Assesment()]
    }    
}
