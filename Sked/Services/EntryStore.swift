//
//  EntryStore.swift
//  Sked
//
//  Created by TJ Barber on 9/5/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation
import CoreData

class EntryStore {
    let viewContext = CoreDataContainer.sharedInstance.persistantContainer.viewContext
    func save(completion: @escaping (Error?) -> Void) {
        self.viewContext.perform { [unowned self] in
            do {
                try self.viewContext.save()
                completion(nil)
            } catch (let error) {
                completion(error)
            }
        }
    }
    
    func delete(_ entry: NSManagedObject, completion: @escaping (Error?) -> Void) {
        self.viewContext.delete(entry)
        self.save { error in
            completion(error)
        }
    }
}
