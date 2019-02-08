//
//  LaunchViewController.swift
//  hermes
//
//  Created by Nishant Jha on 12/22/18.
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.appDelegate.isLoggedIn() {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }        
    }
}
