//
//  CoreDataManager.swift
//  FoodTalk
//
//  Created by Atousa Duprat on 4/23/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let poc = appDelegate.persistentStoreCoordinator
let moc = appDelegate.managedObjectContext


func makeRequest(entity:String)->NSFetchRequest {
    //initMoc()
    let request = NSFetchRequest()
    let entityDescription = NSEntityDescription.entityForName(entity, inManagedObjectContext: moc)
    request.entity = entityDescription
    return request
}


func deleteObject(object:NSManagedObject){
    moc.deleteObject(object)
}

func findRestaurant(descr: restaurantDescriptor)->Restaurant? {
    let request = makeRequest("Restaurant")
    var returnItem : Restaurant? = nil
    let predicate = NSPredicate(format: "name LIKE %@ AND address LIKE %@ AND city LIKE %@ AND state LIKE %@ AND country LIKE %@", descr.name, descr.address, descr.city, descr.state, descr.country)
    request.predicate = predicate
    do {
        let results = try moc.executeFetchRequest(request)
        if results.count > 0 {
            returnItem = results.first as? Restaurant
        }
    } catch {
        let fetchError = error as NSError
        print(fetchError)
    }
    return returnItem
}


func createRestaurantFromDescriptor(d: restaurantDescriptor)->Restaurant {
    let r = NSEntityDescription.insertNewObjectForEntityForName("Restaurant",
                                                                inManagedObjectContext: moc) as! Restaurant
    r.name = d.name
    r.address = d.address
    r.city = d.city
    r.state = d.state
    r.country = d.country
    
    let geocoder = CLGeocoder()
    let address = d.address + ", " + d.city + ", " + d.state + ", " + d.country
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
        
        if let firstPlacemark = placemarks?[0] {
            r.latitude = firstPlacemark.location?.coordinate.latitude
            r.longitude = firstPlacemark.location?.coordinate.longitude
            do {
                try moc.save()
            } catch let error as NSError {
                print(error)
            }
        }
    })

    return r
}

func addRestaurant(descr: restaurantDescriptor) {
    if let result = findRestaurant(descr) {
        ///UIAlertController
        return
    } else {
        var r = createRestaurantFromDescriptor(descr)
        let v = NSEntityDescription.insertNewObjectForEntityForName("Visit", inManagedObjectContext:  moc) as! Visit
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name:"UTC")
        // FIXME!
        let date = dateFormatter.dateFromString("2016-02-05")
        v.date = date
        v.rating = -1
        v.notes = ""
        v.restaurant = r
        do {
            try moc.save()
        } catch let error as NSError {
            print(error)
        }
    }
        
}


func updateRestaurant(restaurant:Restaurant){}

/*
func findVisit(restaurant: Restaurant, visit:Visit)->Visit {return Visit()
}


func addVisit(restaurant: Restaurant, visit:Visit) {
    initMoc()
    let v = NSEntityDescription.insertNewObjectForEntityForName("Visit", inManagedObjectContext:  moc) as! Visit
    v.date = visit.date
    v.favoriteDishes = visit.favoriteDishes
    v.notes = visit.notes
    v.rating = visit.rating
    v.restaurant = restaurant
    do {
        try moc.save()
    } catch let error as NSError {
        print(error)
    }
}


func updateVisit(visit:Visit){}


func deleteVisit(visit:Visit){ //remove entity? not class
    initMoc()
    moc.deleteObject(visit)
    
}


func findPhoto(restaurant: Restaurant, photo:Photo)->Photo {return Photo()
}

func addPhoto(restaurant: Restaurant, visit:Visit, photo:Photo) {
    initMoc()
    let v = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext:  moc) as! Photo
    
    visit.restaurant = restaurant
    photo.visit = visit
    do {
        try moc.save()
    } catch let error as NSError {
        print(error)
    }
}


func updatePhoto(visit:Visit){}


func deletePhoto(visit:Visit){
    initMoc()
    moc.deleteObject(visit)
    
}*/









