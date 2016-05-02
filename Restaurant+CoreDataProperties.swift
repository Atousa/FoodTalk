//
//  Restaurant+CoreDataProperties.swift
//  
//
//  Created by Atousa Duprat on 5/2/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData





extension Restaurant {

    @NSManaged var address: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var state: String?
    @NSManaged var type: String?
    @NSManaged var date: NSDate?
    @NSManaged var visits: NSSet?

}
