//
//  Restaurant+CoreDataProperties.swift
//  
//
//  Created by Atousa Duprat on 4/30/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

@objc class restaurantDescriptor : NSObject {
    var name: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var city: String = ""
    var country: String = ""
    var address: String = ""
    var state: String = ""
    var type: String = ""
}

extension Restaurant {

    @NSManaged var name: String?
    @NSManaged var type: String?

    @NSManaged var address: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var country: String?
    
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?

    @NSManaged var visits: NSSet?
}
