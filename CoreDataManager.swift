//
//  CoreDataManger.swift
//  FoodTalk
//
//  Created by Atousa Duprat on 4/23/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import Foundation
import CoreData

let moc = NSManagedObjectContext()

func initMoc() {
    if(!moc) {
        let appDelegate = UIApplicationsharedApplication.delegate as AppDelegate
        moc = appdelegate.object
    }
    
    func addRestaurant(name :String) {}
    func updateRestaurant(restaurant:Restaurant){}
    func deleteRestaurant(restaurant:Restaurant){}
    func findRestaurant(restaurant:Restaurant)->Restaurant {return Restaurant()}

}

