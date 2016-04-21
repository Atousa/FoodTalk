//
//  FavoriteListViewController.swift
//  FoodTalk
//
//  Created by Eric Hong on 4/19/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController {
    
    
    let consumerKey = "LRm2QLqnKWviXdVCf6O-mA";
    let consumerSecret = "79_-HyVtKeKTjrl_MgsSaLoq5qA";
    let token = "QKQQYxDxrPp3lJFw9dIsOy_n_X-ifcsV";
    let tokenSecret = "ip0M1FBKwgRViXxZIChEjvNFwnw";

    override func viewDidLoad() {
        super.viewDidLoad()

        let client = YLPClient.init(consumerKey: consumerKey, consumerSecret: consumerSecret, token: token, tokenSecret: tokenSecret)
        
        client.searchWithLocation("San Francisco, CA") { (search, error) in
            print(search!)
        }
        
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
