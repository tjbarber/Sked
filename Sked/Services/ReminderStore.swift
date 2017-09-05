//
//  ReminderStore.swift
//  Sked
//
//  Created by TJ Barber on 9/5/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation
import CoreData

class ReminderStore: EntryStore {
    static let sharedInstance = ReminderStore()
    
    func all(completion: @escaping ([Reminder], Error?) -> Void) {
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        // FIXME: In the final app this need to be sorted by the reminding date
        // The Treehouse version of this just saves by location, doesn't care about dates.
        let sortByDateCreated = NSSortDescriptor(key: #keyPath(Reminder.createdAt), ascending: false)
        fetchRequest.sortDescriptors = [sortByDateCreated]
        
        self.viewContext.perform { [unowned self] in
            do {
                let allReminders = try self.viewContext.fetch(fetchRequest)
                completion(allReminders, nil)
            } catch (let error) {
                completion([], error)
            }
        }
    }
    
    
}
