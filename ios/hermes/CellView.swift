//
//  CollectionViewCell.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import UIKit
import JTAppleCalendar
class CellView: JTAppleCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var selectedView: UIView!
}
