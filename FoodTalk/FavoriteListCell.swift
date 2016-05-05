//
//  FavoriteListCell.swift
//  FoodTalk
//
//  Created by Atousa Duprat on 4/23/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit

class FavoriteListCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameOfRestaurant: UILabel!
    
    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var myRatingImage: UIImageView!
    
    @IBOutlet weak var numRatings: UILabel!
    
    
    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet private weak var notesTableView: UITableView!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    var restaurant : Restaurant!
    var  visits : [Visit] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupNotesTableView()
    }
    
    func setupNotesTableView()
    {
        notesTableView.delegate = self
        notesTableView.dataSource = self
       // self.addSubview(notesTableView)
    }
/*
    override func layoutSubviews() {
        super.layoutSubviews()
        notesTableView.frame = CGRectMake(0.2, 0.3, self.bounds.size.width-5, self.bounds.size.height-5)
    }
  */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (restaurant == nil) {
//            notesTableView.hidden = true
            return 0
        }
        
        notesTableView.hidden = false
        self.visits = restaurant.visits?.allObjects as! [Visit]
        visits = visits.sort({ $0.date! > $1.date! })
        
        //print("Num Visits \(restaurant!.name!) = \((restaurant!.visits?.count)!)")
        return (restaurant.visits?.count)!
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotesCell") as! FavoriteListCellNotesSubCell

        let visit = visits[indexPath.row]
        let dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "MM-dd-yyyy" //  "yyyy-MM-dd HH:mm:ss ZZZ"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        //cell.textLabel?.text = "Row " + String(indexPath.row)
        //print("Updating \(restaurant!.name!) Visit Cell \(indexPath.row)")
        if (visit.date != nil) {
            cell.dateLabel?.text = dateFormatter.stringFromDate(visit.date!)
        } else {
            cell.dateLabel?.text = ""
        }
        cell.noteLabel?.text = visit.notes
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Note that you cannot call tableView.cellForRowAtIndexPath(indexPath) here
        // TODO: These heights shouldn't be hardcoded
        return 60
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}

func > (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
}

func < (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
}

