//
//  SearchFoodPlacesViewController.swift
//  FoodTalk
//
//  Created by Eric Hong on 4/22/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit

class SearchFoodPlacesViewController: UIViewController {
    
    
    @IBOutlet weak var searchListTableView: UITableView!

    let consumerKey = "LRm2QLqnKWviXdVCf6O-mA";
    let consumerSecret = "79_-HyVtKeKTjrl_MgsSaLoq5qA";
    let token = "QKQQYxDxrPp3lJFw9dIsOy_n_X-ifcsV";
    let tokenSecret = "ip0M1FBKwgRViXxZIChEjvNFwnw";
    
    var locationFromWatson:String?
    
    var searchResult:YLPSearch?
    var businessResult:NSArray?
    var arrayOfBusinesses: [AnyObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let client = YLPClient.init(consumerKey: consumerKey, consumerSecret: consumerSecret, token: token, tokenSecret: tokenSecret)
        
        if let locationString = locationFromWatson {
            client.searchWithLocation(locationString) { (search, error) in
                self.searchResult = search
                self.businessResult = (self.searchResult?.businesses)! as NSArray
                
                for business in self.businessResult! {
                    self.arrayOfBusinesses.append(business)
                    
                }
                self.searchListTableView.reloadData()
            }
        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfBusinesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.arrayOfBusinesses[indexPath.row].name
        
        return cell
        
    }

}
