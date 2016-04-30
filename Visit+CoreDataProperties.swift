//
//  Visit+CoreDataProperties.swift
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

class visitDescriptor {
    
    var date: NSDate? = nil
    var rating: NSNumber? = 0
    var favoriteDishes: String? = ""
    var notes: String? = ""
    var photos: NSSet? = nil
    
}

extension Visit {

    @NSManaged var date: NSDate?
    @NSManaged var rating: NSNumber?
    @NSManaged var favoriteDishes: String?
    @NSManaged var notes: String?
    @NSManaged var photos: NSSet?
    @NSManaged var restaurant: Restaurant?

}
