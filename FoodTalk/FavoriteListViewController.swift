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
    let resDemo1 = restaurantDescriptor()
    let resDemo2 = restaurantDescriptor()
    let resDemo3 = restaurantDescriptor()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var visitDemo = Visit()
        //var photo = Photo()
        
        
        resDemo1.name = "Farmhouse Kitchen"
        resDemo1.address =  "710 Florida St"
        resDemo1.city = "San Francisco"
        resDemo1.state = "CA"
        resDemo1.country = "United States"
       
        resDemo2.name = "Chez Panisse"
        resDemo2.address =  "1517 Shattuck Ave"
        resDemo2.city = "Berkeley"
        resDemo2.state = "CA"
        resDemo2.country = "United States"
        
        resDemo3.name = "Flour + Water"
        resDemo3.address =  "2401 Harrison St"
        resDemo3.city = "San Francisco"
        resDemo3.state = "CA"
        resDemo3.country = "United States"
        
        
        
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
        self.locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        self.restaurant = self.findNearbyRestaurants(location)
        self.tableView.reloadData()

        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location detection needs to be enabled in the simulator")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        locationManager.stopUpdatingLocation()
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        
    }
    
    
    
    
   /* func locationManager(manager: CLLocationManager, didUpdateLocations loc: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        self.location = loc.last!
        self.restaurant = self.findNearbyRestaurants(loc.last!)
        print(self.restaurant.count)
        self.tableView.reloadData()
    }*/
    

    func closeEnough(candidate: Restaurant) -> Bool {
        let dest =  CLLocation(latitude: Double(candidate.latitude!),longitude: Double(candidate.longitude!))

        let distance = calculateDistanceBetweenTwoLocations(self.location, destination: dest)
        
        return distance <= 0.2
    }
    
    
    func findNearbyRestaurants(location:CLLocation)-> [Restaurant] {
        let request = makeRequest("Restaurant")

        /*let closeEnoughPredicate = NSPredicate { (candidate, _) in
            let dest =  CLLocation(latitude: Double(candidate.latitude!),longitude: Double(candidate.longitude!))
            
            let distance = self.calculateDistanceBetweenTwoLocations(self.location, destination: dest)
            
            return distance <= 10
        }*/
        
        //request.predicate = closeEnoughPredicate
        //print(request.predicate)
 
        let sort = NSSortDescriptor(key:"name", ascending:true)
        request.sortDescriptors = [sort]
        
        do {
            let results = try moc.executeFetchRequest(request)
            self.restaurant = results  as! [Restaurant]
            
            //let closeEnoughPredicate = NSPredicate { (results, _) in
                //let dest =  CLLocation(latitude: Double(results.latitude!),longitude: Double(results.longitude!))
                
                //let distance = self.calculateDistanceBetweenTwoLocations(self.location, destination: dest)
                
                //return distance <= 10
            

            
            //return results as! [Restaurant]
        
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
       return self.restaurant
    }
    
        
        
    
    func calculateDistanceBetweenTwoLocations(source:CLLocation,destination:CLLocation) -> Double{
        
        var distanceMeters = source.distanceFromLocation(destination)
        var distanceKM = distanceMeters / 1000
        let roundedTwoDigit = distanceKM
        return roundedTwoDigit
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.restaurant.count == 0  {
             addRestaurant(resDemo1, presentViewController: self)
             addRestaurant(resDemo2, presentViewController: self)
             addRestaurant(resDemo3, presentViewController: self)
             self.restaurant = findNearbyRestaurants(location)
            
        }
        
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
