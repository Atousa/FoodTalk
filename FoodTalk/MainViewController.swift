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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Makes a gradient of (top)light blue to (bot)dark blue
//        let lightRed = UIColor(red: 243/255, green: 167/255, blue: 18/255, alpha: 1.0)
//        let darkRed = UIColor(red: 255/255, green: 42/255, blue: 104/255, alpha: 1.0)
//        let gradient:CAGradientLayer = CAGradientLayer()
//        gradient.frame = view.bounds
//        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.whiteColor().CGColor]
//        view.layer.insertSublayer(gradient, atIndex: 0)
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.newPlaceButton.tintColor = UIColor.whiteColor()
        
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
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
