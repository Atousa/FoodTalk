//
//  DialogueViewController.swift
//  FoodTalk
//
//  Created by Eric Hong on 4/19/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit

class DialogueViewController: UIViewController,UITableViewDelegate {
    

    @IBOutlet weak var DialogueTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DialogueTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("DialogueCell") as! DialogueCell
        cell.myDialogueTextField.text = "Hello"
        cell.WatsonDialogueTextField.text = " I am Watson Hello"
        cell.WatsonDialogueImage.image = UIImage(named: "watson.png")
        
    }

    @IBAction func OnPressedEthnicity(sender: AnyObject) {
    }
}
    

   

