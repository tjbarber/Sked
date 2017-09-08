//
//  Reminder+CoreDataProperties.swift
//  Sked
//
//  Created by TJ Barber on 9/8/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var entry: String?
    @NSManaged public var location: NSObject?
    @NSManaged public var notes: String?

}
