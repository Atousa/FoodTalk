//
//  Resturant+CoreDataProperties.swift
//  
//
//  Created by Atousa Duprat on 4/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Resturant {

    @NSManaged var name: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var dates: NSDate?
    @NSManaged var images: NSData?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var favoritDishes: String?
    @NSManaged var rate: NSNumber?

}
