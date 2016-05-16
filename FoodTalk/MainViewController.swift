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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "FoodTalk"

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.newPlaceButton.backgroundColor = UIColor.whiteColor()
        self.newPlaceButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        
        self.favoritePlaceButton.backgroundColor = UIColor.whiteColor()
        self.favoritePlaceButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    }
    
    
    @IBAction func onDiscoverPressed(sender: AnyObject) {
        performSegueWithIdentifier("goToDialogVC", sender: self)
    }
    
    @IBAction func onFavoritePressed(sender: AnyObject) {
        performSegueWithIdentifier("goToFavoriteVC", sender: self)
    }
}
