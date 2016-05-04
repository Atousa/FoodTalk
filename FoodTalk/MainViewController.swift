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
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var locationAddress: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "FoodTalk"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
//        Makes a gradient of (top)light blue to (bot)dark blue
//        let lightRed = UIColor(red: 243/255, green: 167/255, blue: 18/255, alpha: 1.0)
//        let darkRed = UIColor(red: 255/255, green: 42/255, blue: 104/255, alpha: 1.0)
//        let gradient:CAGradientLayer = CAGradientLayer()
//        gradient.frame = view.bounds
//        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.whiteColor().CGColor]
//        view.layer.insertSublayer(gradient, atIndex: 0)
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.newPlaceButton.backgroundColor = UIColor.whiteColor()
        self.newPlaceButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        
        self.favoritePlaceButton.backgroundColor = UIColor.whiteColor()
        self.favoritePlaceButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
//        var foodString = "Food"
//        var completedFoodString = NSMutableAttributedString()
//        completedFoodString = NSMutableAttributedString(string: foodString as String, attributes: [NSFontAttributeName:UIFont(name:"Courier", size: 18.0)!, NSForegroundColorAttributeName:(UIColor.whiteColor())])
//        
//        
//        var talkString = "Talk"
//        var completedTalkString = NSMutableAttributedString()
//        completedTalkString = NSMutableAttributedString(string: talkString as String, attributes: [NSFontAttributeName:UIFont(name:"Courier", size: 18.0)!])
//
//        var navLabel = UILabel()
//        navLabel.attributedText = completedFoodString.appendAttributedString(completedTalkString)
//        navLabel.sizeToFit()
        
        
//        self.navigationItem.titleView = navLabel
        
        
        
    }
    
    
    @IBAction func onDiscoverPressed(sender: AnyObject) {
        if(locationAddress == nil) {
            alertEnableLocationServicesRequired()
            return
        }
        performSegueWithIdentifier("goToDialogVC", sender: self)
    }
    @IBAction func onFavoritePressed(sender: AnyObject) {
        if(locationAddress == nil) {
            alertEnableLocationServicesRequired()
            return
        }
        performSegueWithIdentifier("goToFavoriteVC", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dialogueVC = segue.destinationViewController as? DialogueViewController
        if (dialogueVC != nil) {
            dialogueVC!.location = self.location
            dialogueVC!.locationAddress = self.locationAddress!
            return
        }
        let FavoriteVC = segue.destinationViewController as? FavoriteListViewController
        if (FavoriteVC != nil) {
            FavoriteVC!.location = self.location!
            FavoriteVC!.locationAddress = self.locationAddress!
            return
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        locationManager.stopUpdatingLocation()
        if location?.verticalAccuracy < 1000 && location?.horizontalAccuracy < 1000 {
            self.location = location
            reverseGeoCode(location!)
        }
    }
    
    func reverseGeoCode(location: CLLocation) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { (placemark, error) in
            let placemark = placemark?.first
            self.locationAddress = "\(placemark!.subThoroughfare!) \(placemark!.thoroughfare!) \(placemark!.locality!), \(placemark!.administrativeArea!)"
            print("Location detected: \(self.locationAddress!)")
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        alertEnableLocationServicesRequired()
    }
    
    func alertEnableLocationServicesRequired() {
        let alert = UIAlertController(title: "Alert", message: "You must enable location services to get search results", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
