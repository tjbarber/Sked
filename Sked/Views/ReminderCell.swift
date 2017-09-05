//
//  ReminderCell.swift
//  Sked
//
//  Created by TJ Barber on 9/5/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    static let identifier = "reminderCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configure(_ reminder: Reminder) {
        
    }
}
