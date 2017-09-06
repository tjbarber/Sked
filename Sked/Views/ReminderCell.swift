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
    
    @IBOutlet weak var reminderEntryLabel: UILabel!
    @IBOutlet weak var reminderLocationLabel: UILabel!
    @IBOutlet weak var reminderTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ reminder: Reminder) {
        self.reminderEntryLabel.text    = nil
        self.reminderLocationLabel.text = nil
        self.reminderTimeLabel.text     = nil
        
        self.reminderEntryLabel.text = reminder.entry
    }
}
