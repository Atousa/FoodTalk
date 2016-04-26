//
//  FavoriteListViewController.swift
//  FoodTalk
//
//  Created by Eric Hong on 4/19/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


class FavoriteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate {
    
   
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var location = CLLocation()
    var restaurant = [Restaurant]()
    let predicate = NSPredicate()
    var persistentStoreCoordinator = NSPersistentStoreCoordinator()
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)


    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        persistentStoreCoordinator = appDelegate.persistentStoreCoordinator
        managedObjectContext = appDelegate.managedObjectContext

        let resDemo = restaurantDescriptor()
        //var visitDemo = Visit()
        //var photo = Photo()
        
        
        resDemo.name = "Farmhouse Kitchen"
        resDemo.address =  "710 Florida St"
        resDemo.city = "San Francisco"
        resDemo.state = "CA"
        resDemo.country = "United States"
        addRestaurant(resDemo)
        /*
        visitDemo.restaurant = resDemo
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name:"UTC")
        let date = dateFormatter.dateFromString("2016-02-05")
        visitDemo.date = date
        visitDemo.rating = 4
        visitDemo.notes = " I loved the vibe of the resturant with all Thai new year decoration with my family, all the dished looks fantastic"
        photo.visit = visitDemo
        photo.comment = "pictures with my family"
        let image = UIImage(contentsOfFile: "IMG_2152")
        photo.image = UIImagePNGRepresentation(image!)! as NSData
        */
        
        //addVisit(resDemo,visit:visitDemo)
        //addPhoto(resDemo, visit: visitDemo, photo: photo)
        
        title = "\"List of My Favorite Restaurants\""
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        //self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations loc: [CLLocation]) {
        self.location = loc.last!
        self.restaurant = self.findNearbyRestaurants(loc.last!)
        self.tableView.reloadData()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location detection needs to be enabled in the simulator")
    }

    //should go to service
    func makeRequest()->NSFetchRequest {
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Restaurant", inManagedObjectContext: self.managedObjectContext)
        request.entity = entityDescription
        return request
    }
    
    
    func closeEnough(candidate: Restaurant) -> Bool {
        let dest =  CLLocation(latitude: Double(candidate.latitude!),longitude: Double(candidate.longitude!))

        let distance = calculateDistanceBetweenTwoLocations(self.location, destination: dest)
        
        return distance <= 10
    }
    
    
    func findNearbyRestaurants(location:CLLocation)-> [Restaurant] {
        let request = self.makeRequest()
/*
        let closeEnoughPredicate = NSPredicate { (candidate, _) in
            let dest =  CLLocation(latitude: Double(candidate.latitude!),longitude: Double(candidate.longitude!))
            
            let distance = self.calculateDistanceBetweenTwoLocations(self.location, destination: dest)
            
            return distance <= 10
        }
        request.predicate = closeEnoughPredicate
 */
        let sort = NSSortDescriptor(key:"name", ascending:true)//closure
        request.sortDescriptors = [sort]
        
        do {
            let results = try self.managedObjectContext.executeFetchRequest(request)
            return results as! [Restaurant]
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
        
        
    
    func calculateDistanceBetweenTwoLocations(source:CLLocation,destination:CLLocation) -> Double{
        
        var distanceMeters = source.distanceFromLocation(destination)
        var distanceKM = distanceMeters / 1000
        let roundedTwoDigit = distanceKM //?
        return roundedTwoDigit
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurant.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell", forIndexPath: indexPath) as! FavoriteListCell
        let r = self.restaurant[indexPath.row]
        cell.nameOfResturant.text = r.name
    
        return cell
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
