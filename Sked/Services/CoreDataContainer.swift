//
//  DataStore.swift
//  Sked
//
//  Created by TJ Barber on 9/5/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation
import CoreData

class CoreDataContainer {
    static let sharedInstance = CoreDataContainer()
    
    let persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sked")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error setting up Core Data.")
            }
        }
        return container
    }()
}
