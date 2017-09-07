//
//  EntryTypeSelectionController.swift
//  Sked
//
//  Created by TJ Barber on 8/31/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit
import EventKit

class AddReminderController: UIViewController {
    
    var reminder: Reminder?
    var selectedLocation: CLLocation?
    
    @IBOutlet weak var reminderEntryTextField: UITextField!
    
    @IBAction func save(_ sender: Any) {
        if self.reminder == nil {
            self.reminder = Reminder(context: CoreDataContainer.sharedInstance.persistantContainer.viewContext)
        }
        
        guard let reminder = self.reminder else {
            fatalError("Got to save method with no reminder object in memory.")
        }
        
        if reminder.createdAt == nil {
            reminder.createdAt = NSDate()
        }
        
        if let reminderEntry = reminderEntryTextField.text {
            if reminderEntry.isEmpty {
                AlertHelper.showAlert(withTitle: "No reminder description!", withMessage: "We need to know what we're reminding you of.", presentingViewController: self)
                return
            }
            reminder.entry = reminderEntry
        }

        ReminderStore.sharedInstance.save { error in
            if let error = error {
                AlertHelper.showAlert(withTitle: "Error", withMessage: error.localizedDescription, presentingViewController: self)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBar = UINavigationBar.appearance()
        navigationBar.setTitleVerticalPositionAdjustment(3.0, for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "addLocationSegue":
                let navigationController = segue.destination as! UINavigationController
                let locationSearchController = navigationController.topViewController as! LocationSearchController
                locationSearchController.reminder = self.reminder
            default: break
            }
        }
    }

    @IBAction func closeAddReminder(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
