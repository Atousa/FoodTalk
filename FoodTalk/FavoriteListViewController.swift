//
//  FavoriteListViewController.swift
//  FoodTalk
//
//  Created by Eric Hong on 4/19/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let consumerKey = "LRm2QLqnKWviXdVCf6O-mA";
    let consumerSecret = "79_-HyVtKeKTjrl_MgsSaLoq5qA";
    let token = "QKQQYxDxrPp3lJFw9dIsOy_n_X-ifcsV";
    let tokenSecret = "ip0M1FBKwgRViXxZIChEjvNFwnw";
    
    var searchResult:YLPSearch?
    var businessResult:NSArray?
    var arrayOfBusiness: NSMutableArray?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let client = YLPClient.init(consumerKey: consumerKey, consumerSecret: consumerSecret, token: token, tokenSecret: tokenSecret)
        
        client.searchWithLocation("Nob Hill, San Francisco, CA") { (search, error) in
            self.searchResult = search
            self.businessResult = (self.searchResult?.businesses)! as NSArray
            
            for business in self.businessResult! {
                self.arrayOfBusiness?.addObject(business)
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.arrayOfBusiness?[indexPath.row].name
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
