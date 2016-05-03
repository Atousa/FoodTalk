//
//  FavoriteListDetails.swift
//  
//
//  Created by Atousa Duprat on 4/29/16.
//
//

import UIKit

class FavoriteListDetails: UIViewController,UITextViewDelegate {

    var r : Restaurant!
    var v = visitDescriptor()

    
    @IBOutlet weak var addNotetextview: UITextView!
    
    
    override func viewDidLoad() {
        self.addNotetextview.text = ""
        self.addNotetextview.backgroundColor = UIColor.lightGrayColor()
        addNotetextview.delegate = self
        
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            self.addNotes(text)
            return false
        }
            return true
    }
    
    
    func addNotes(text:String) {
        v.notes = text
        v.date = NSDate()
        CDM.addVisit(r, descr: v)
        addNotetextview.text = ""
        
    }
    
}

            



    

