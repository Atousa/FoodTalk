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
    
    func initStuff(VC: CLLocationManagerDelegate) {
        
        locationObtained = false
        locationQuery = true
        locationManager.delegate = VC
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestLocation()
        }
        
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

    