//
//  Location.swift
//  FoodTalk
//
//  Created by Atousa Duprat on 5/5/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit
import CoreLocation


class Location: CLLocation, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var locationObtained = false
    var locationQuery = true
    var location: CLLocation?
    var locationAddress: String?
    
    func initStuff() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        locationObtained = true;
        if location?.verticalAccuracy < 1000 && location?.horizontalAccuracy < 1000 {
            self.location = location
            reverseGeoCode(location!)
        }
    }
    
    func reverseGeoCode(location: CLLocation) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            let placemark = placemarks?.first
//            self.locationAddress = String("\(placemark!.subThoroughfare!) \(placemark!.thoroughfare!) \(placemark!.locality!), \(placemark!.administrativeArea!)")
            self.locationAddress = String()
            if (placemark!.subThoroughfare != nil) {
                self.locationAddress! += placemark!.subThoroughfare!
            }
            if (placemark!.thoroughfare != nil) {
                self.locationAddress! += " " + placemark!.thoroughfare!
            }
            if (placemark!.locality != nil) {
                self.locationAddress! += " " + placemark!.locality!
            }
            if (placemark!.administrativeArea != nil) {
                self.locationAddress! += ", " + placemark!.administrativeArea!
            }
            
            print("Location detected: \(self.locationAddress!)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError, vc:UIViewController) {
        alertEnableLocationServicesRequired(vc)
    }
    
    func alertEnableLocationServicesRequired(viewController: UIViewController) {
        if(locationQuery == false) {
            return
        }
        
        locationQuery = false
        let alert = UIAlertController(title: "Alert", message: "You must enable location services to get search results", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}

    