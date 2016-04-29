//
//  FavoriteListDetails.swift
//  
//
//  Created by Atousa Duprat on 4/29/16.
//
//

import UIKit

class FavoriteListDetails: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var r : Restaurant!
    var enumerator =  NSEnumerator()

    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var notesTableView: UITableView!
   
    
    override func viewDidLoad() {
        enumerator = (r.visits?.objectEnumerator())!
        self.notesTableView.delegate = self
        self.notesTableView.reloadData()
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(" hello there: ",r.visits?.count)
        return (r.visits?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notesCell")
        let myVisit = enumerator.nextObject() as! Visit?
        cell?.textLabel!.text = myVisit?.notes
        return cell!
    }
}
    



    

