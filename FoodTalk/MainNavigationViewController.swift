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
        let customRedColor = UIColor(red: 253/255, green: 1/255, blue: 7/255, alpha: 1.0)
        self.navigationBar.barTintColor = customRedColor
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Optima-Bold", size: 25)!]
        
//        Changes the back button on the nav bar to be white
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.whiteColor()
        
        
        
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
