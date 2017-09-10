//
//  EntryTypeSelectionController.swift
//  Sked
//
//  Created by TJ Barber on 8/31/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit
import EventKit
import MapKit

enum ReminderEntryControllerState {
    case creating
    case editing
}

class ReminderEntryController: UIViewController {
    
    var reminder: Reminder?
    var selectedMapItem: MKMapItem?
    var selectedPlacemark: MKPlacemark?
    var controllerState: ReminderEntryControllerState = .creating
    let eventStore = EKEventStore()
    
    @IBOutlet weak var reminderEntryTextField: UITextField!
    @IBOutlet weak var reminderLocationTextLabel: UILabel!
    @IBOutlet weak var reminderNotesTextField: UITextField!
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        self.save()
    }
    
    @IBAction func closeReminderEntry(_ sender: UIBarButtonItem) {
        self.closeReminderEntry()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBar = UINavigationBar.appearance()
        navigationBar.setTitleVerticalPositionAdjustment(3.0, for: .default)
        setNavigationBarTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let reminder = self.reminder else { return }
        
        self.reminderEntryTextField.text = reminder.entry
        self.reminderNotesTextField.text = reminder.notes
        
        if self.selectedPlacemark == nil && reminder.location != nil {
            self.selectedPlacemark = reminder.location as? MKPlacemark
        }
        
        displayLocationString()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayLocationString()
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "addLocationSegue":
            if CLLocationManager.authorizationStatus() != .authorizedAlways {
                AlertHelper.showAlert(withTitle: "Error", withMessage: "You must give us permission to access location services to add a location to your reminder!", presentingViewController: self)
                return false
            }
        default: break
        }
        return true
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
}

// MARK: - Helper methods
extension ReminderEntryController {
    func closeReminderEntry() {
        switch self.controllerState {
        case .creating: self.dismiss(animated: true, completion: nil)
        case .editing: self.navigationController?.popViewController(animated: true)
        }
    }
    
    func displayLocationString() {
        if let placemark = self.selectedPlacemark {
            if let street = placemark.thoroughfare,
                let city = placemark.locality,
                let state = placemark.administrativeArea {
                self.reminderLocationTextLabel.text = "\(street), \(city), \(state)"
            }
        }
    }
    
    func setNavigationBarTitle() {
        var navigationBarTitle: String
        switch self.controllerState {
        case .editing: navigationBarTitle = "EDIT REMINDER"
        case .creating: navigationBarTitle = "ADD REMINDER"
        }
        self.navigationBarTitle.title = navigationBarTitle
    }
}

// MARK: - Data Persistance Methods
extension ReminderEntryController {
    // We're only ever going to save the reminder referenced on self
    // So we're going to do all the handling of unwrapping here
    func save() {
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
        
        if let selectedPlacemark = self.selectedPlacemark {
            reminder.location = selectedPlacemark
        }
        
        if let reminderNote = reminderNotesTextField.text {
            reminder.notes = reminderNote
        }
        
        ReminderStore.sharedInstance.save { [unowned self] error in
            if let error = error {
                AlertHelper.showAlert(withTitle: "Error", withMessage: error.localizedDescription, presentingViewController: self)
                return
            }
            
            if let selectedMapItem = self.selectedMapItem {
                let calendarReminder = EKReminder(eventStore: self.eventStore)
                
                if let entry = reminder.entry {
                    calendarReminder.title = entry
                }
                
                calendarReminder.notes = reminder.notes
                let alarm = EKAlarm(relativeOffset: 0)
                let locationGeofence = EKStructuredLocation(mapItem: selectedMapItem)
                alarm.structuredLocation = locationGeofence
                calendarReminder.addAlarm(alarm)
            }
            
            self.closeReminderEntry()
        }
    }
}
