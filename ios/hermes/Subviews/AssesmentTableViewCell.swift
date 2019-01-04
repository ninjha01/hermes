//
//  AssesmentTableViewCell.swift
//  hermes
//
//  Created by Nishant Jha on 1/4/19.
//  Copyright © 2019 Nishant Jha. All rights reserved.
//

import UIKit

class AssesmentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    var assesment: Assesment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
