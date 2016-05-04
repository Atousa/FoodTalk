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
import CoreLocation

@objc class restaurantDescriptor : NSObject {
    var name: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var city: String = ""
    var country: String = ""
    var address: String = ""
    var state: String = ""
    var type: String = ""
    var date: NSDate = NSDate()
    var isExpanded: Bool = false
}

func calculateDistanceBetweenTwoLocations(source:CLLocation, destination:CLLocation) -> Double {
    let distanceMeters = source.distanceFromLocation(destination)
    let distanceKM = distanceMeters / 1000.0
    let distanceMI = distanceKM * 0.621371
    return distanceMI
}

extension Restaurant {
    func distance(from: CLLocation)->Double {
        return calculateDistanceBetweenTwoLocations(from, destination: CLLocation(latitude: Double(latitude!), longitude: Double(longitude!)))
    }
    
    func rating()->Int {
        let numVisits = (visits?.count)!
        if(numVisits == 0) {
            return 0
        }
        var Rating = 0.0
        for i in 0...numVisits-1 {
            Rating += Double((visits?.allObjects[i] as! Visit).rating!)
        }
        Rating = round(2 * Rating/Double(numVisits))
        return Int(Rating)
    }

    @NSManaged var address: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var date: NSDate?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var state: String?
    @NSManaged var type: String?
    @NSManaged var visits: NSSet?
    @NSManaged var isExpanded: NSNumber?}
