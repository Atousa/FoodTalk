//
//  MainNavigationViewController.swift
//  FoodTalk
//
//  Created by Eric Hong on 4/25/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let customRedColor = UIColor(red: 255/255, green: 13/255, blue: 13/255, alpha: 1.0)
        self.navigationBar.barTintColor = customRedColor
        self.navigationBar.shadowImage = UIImage(named: "tomato")
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Optima-Bold", size: 25)!]
        
//        Changes the back button on the nav bar to be white
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.whiteColor()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
