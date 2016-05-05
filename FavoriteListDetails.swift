//
//  FavoriteListDetails.swift
//  
//
//  Created by Atousa Duprat on 4/29/16.
//
//

import UIKit

class FavoriteListDetails: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    var restaurant : Restaurant!

    
    @IBOutlet var Name: UILabel!
    @IBOutlet var Previous: UILabel!
    @IBOutlet var Date: UILabel!
    @IBOutlet var Note: UITextView!
    @IBOutlet var Rating: UITextField!
    
    override func viewDidLoad() {
        // TODO: if visit today, retrieve data
        self.Note.text = ""
        self.Rating.text = ""
        Name.text = restaurant.name
        Previous.text = "" // String(format:"%d Previous Visits", restaurant.visits!.count)
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy" //  "yyyy-MM-dd HH:mm:ss ZZZ"
        self.Date?.text = dateFormatter.stringFromDate(now)
        self.Note.delegate = self
        self.Rating.delegate = self
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func onDonePressed(sender: AnyObject) {
        if(Note.text == "") {
            let alert = UIAlertController(title: "Alert", message: "You must write notes before saving", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let r = Int(Rating.text!)
        if(r == nil || r!<0 || r!>5) {
            let alert = UIAlertController(title: "Alert", message: "Rating must be an integer [0-5]", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.addNotes()
        self.performSegueWithIdentifier("unwindToFavoriteList", sender: self)
    }
    
    func addNotes() {
        let v = visitDescriptor()
        v.date = NSDate()
        v.rating = Int(Rating.text!)!
        //v.favoriteDishes
        v.notes = Note.text
        //v.photos

        CDM.addVisit(restaurant, descr: v)
    }
    
}

            



    

