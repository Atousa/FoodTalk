//
//  Restaurant+CoreDataProperties.swift
//  FoodTalk
//
//  Created by Atousa Duprat on 4/23/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData


class restaurantDescriptor {
    var name: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var city: String = ""
    var country: String = ""
    var address: String = ""
    var state: String = ""
}

extension Restaurant {

    @NSManaged var name: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var address: String?
    @NSManaged var state: String?
    @NSManaged var visits: NSSet?

}

