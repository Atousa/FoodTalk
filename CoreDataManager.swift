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

@objc class CDM : NSObject {

static func makeRequest(entity:String)->NSFetchRequest {
    let request = NSFetchRequest()
    let entityDescription = NSEntityDescription.entityForName(entity, inManagedObjectContext: moc)
    request.entity = entityDescription
    return request
}


static func deleteObject(object:NSManagedObject){
    moc.deleteObject(object)
    do {
        try moc.save()
    } catch let error as NSError {
        print(error)
    }
}


static func findRestaurant(descr: restaurantDescriptor)->Restaurant? {
    let request = makeRequest("Restaurant")
    var returnItem : Restaurant? = nil
    let predicate = NSPredicate(format: "name LIKE %@ AND address LIKE %@" , descr.name, descr.address)
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


static func createRestaurantFromDescriptor(d: restaurantDescriptor)->Restaurant {
    let r = NSEntityDescription.insertNewObjectForEntityForName("Restaurant",
                                                                inManagedObjectContext: moc) as! Restaurant
    r.name = d.name
    r.address = d.address
    r.city = d.city
    r.state = d.state
    r.country = d.country
    r.type = d.type
    
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


static func addRestaurant(descr: restaurantDescriptor, presentViewController: UIViewController) {
    let result = findRestaurant(descr)
    if result != nil {
        let alert = UIAlertController(title: "Alert", message: "This place is in your favorite list", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController.presentViewController(alert, animated: true, completion: nil)
    } else {
        var r = createRestaurantFromDescriptor(descr)
        do {
            try moc.save()
        } catch let error as NSError {
            print(error)
        }
    }
}


static func updateRestaurant(restaurant:Restaurant){}

static func findVisit(restaurant: Restaurant, visit:Visit)->Visit {return Visit()
}


static func addVisit(restaurant: Restaurant, descr: visitDescriptor) {
    let v = NSEntityDescription.insertNewObjectForEntityForName("Visit", inManagedObjectContext:  moc) as! Visit
    v.date = descr.date
    v.favoriteDishes = descr.favoriteDishes
    v.notes = descr.notes
    v.rating = descr.rating
    v.restaurant = restaurant
    
    do {
        try moc.save()
    } catch let error as NSError {
        print(error)
    }
}


static func updateVisit(visit:Visit){}




/* 
static func findPhoto(restaurant: Restaurant, photo:Photo)->Photo {return Photo()
}

static func addPhoto(restaurant: Restaurant, visit:Visit, photo:Photo) {
    let v = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext:  moc) as! Photo
    
    photo.visit = visit
    photo.visit = visit
    do {
        try moc.save()
    } catch let error as NSError {
        print(error)
    }
}


static func updatePhoto(visit:Visit){}
     
*/

}