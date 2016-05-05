//
//  MainViewController.swift
//  FoodTalk
//
//  Created by Eric Hong on 4/19/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var newPlaceButton: UIButton!
    @IBOutlet weak var favoritePlaceButton: UIButton!
    
//    let locationManager = CLLocationManager()
//    var locationObtained = false
//    var locationQuery = true
//    var location: CLLocation?
//    var locationAddress: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "FoodTalk"
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()

//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            while(!self.locationObtained && self.locationQuery) {
//                if CLLocationManager.locationServicesEnabled() {
//                    self.locationManager.requestLocation()
//                }
//                sleep(1);
//            }
//        }
        

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.newPlaceButton.backgroundColor = UIColor.whiteColor()
        self.newPlaceButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        
        self.favoritePlaceButton.backgroundColor = UIColor.whiteColor()
        self.favoritePlaceButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.delegate = self
    }
    
    
    @IBAction func onDiscoverPressed(sender: AnyObject) {
        performSegueWithIdentifier("goToDialogVC", sender: self)
    }
    @IBAction func onFavoritePressed(sender: AnyObject) {
        performSegueWithIdentifier("goToFavoriteVC", sender: self)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let dialogueVC = segue.destinationViewController as? DialogueViewController
//        if (dialogueVC != nil) {
//            dialogueVC!.location = self.location
//            dialogueVC!.locationAddress = self.locationAddress
//            return
//        }
//        let FavoriteVC = segue.destinationViewController as? FavoriteListViewController
//        if (FavoriteVC != nil) {
//            FavoriteVC!.location = self.location
//            FavoriteVC!.locationAddress = self.locationAddress
//            return
//        }
//    }

//MARK: Location methods
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
//        locationManager.stopUpdatingLocation()
//        locationObtained = true;
//        if location?.verticalAccuracy < 1000 && location?.horizontalAccuracy < 1000 {
//            self.location = location
//            reverseGeoCode(location!)
//        }
//    }
    
//    func reverseGeoCode(location: CLLocation) {
//        let geoCoder = CLGeocoder()
//        
//        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
//            let placemark = placemarks?.first
//            self.locationAddress = String("\(placemark!.subThoroughfare!) \(placemark!.thoroughfare!) \(placemark!.locality!), \(placemark!.administrativeArea!)")
//            self.locationAddress = String()
//            if (placemark!.subThoroughfare != nil) {
//                self.locationAddress! += placemark!.subThoroughfare!
//            }
//            if (placemark!.thoroughfare != nil) {
//                self.locationAddress! += " " + placemark!.thoroughfare!
//            }
//            if (placemark!.locality != nil) {
//                self.locationAddress! += " " + placemark!.locality!
//            }
//            if (placemark!.administrativeArea != nil) {
//                self.locationAddress! += ", " + placemark!.administrativeArea!
//            }
//
//            print("Location detected: \(self.locationAddress!)")
//        }
//    }
//
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        alertEnableLocationServicesRequired()
//    }
//    
//    func alertEnableLocationServicesRequired() {
//        if(locationQuery == false) {
//            return
//        }
//        
//        locationQuery = false
//        let alert = UIAlertController(title: "Alert", message: "You must enable location services to get search results", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    

}
