//
//  DialogueViewController.swift
//  FoodTalk
//
//  Created by Eric Hong on 4/19/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit
import WatsonDeveloperCloud
import AVFoundation

class DialogueViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate, AVAudioRecorderDelegate {
    

    @IBOutlet weak var DialogueTableView: UITableView!
    
    var conversationID: Int?
    var clientID: Int?
    var service: Dialog?
    var tts: TextToSpeech?
    var dialogID: Dialog.DialogID?
    var dialogLog: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DialogueTableView.separatorStyle = .None
        
        self.service = Dialog(username: "585c94ca-d7e2-4b6e-9b8c-e28e00d27b55", password: "keuvuyZjRb7O")
        //self.tts = TextToSpeech(username: "846d202a-20ad-4fbb-b033-dee0a559c4b4", password: "LQJNUGIkfNrc")
        
        
        let dialogName = "nameo"
        self.service!.getDialogs() { dialogs, error in
            if error != nil {
                print(error?.userInfo)
                return
            }
            for dialog in dialogs! {
                if(dialog.name == dialogName)
                {
                    self.dialogID = dialog.dialogID
                    self.startDialogue()
                    return
                }
            }
        }
        
        let path = NSBundle.mainBundle().pathForResource("pizza_sample", ofType: "xml")
        let url = NSURL.fileURLWithPath(path!)
        self.service!.createDialog(dialogName, fileURL: url) { dialogID, error in
            if error != nil {
                print(error?.userInfo)
                return
            }
            self.dialogID = dialogID
            self.startDialogue()
        }
    }


    func startDialogue() {
        self.service!.converse(self.dialogID!) { response, error in
            if error != nil {
                print(error?.userInfo)
                return
            }
            self.conversationID = response?.conversationID
            self.clientID = response?.clientID
            self.dialogLog.append((response?.response![0])!)

            //reload tableview from main thread
            dispatch_async(dispatch_get_main_queue()) {
                self.DialogueTableView.reloadData()
            }
        }
    }
    
    /*func speak(text: String) {
        self.tts!.synthesize(text) {
            data, error in
            if let data = data {
                do {
                    let audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    sleep(UInt32(audioPlayer.duration+1))
                } catch {
                    NSLog("Bad sound data")
                }
            }
        }
    }*/
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print(textField.text!)
        self.dialogLog.append(textField.text!)
        print("Array: \(self.dialogLog)")

        resignFirstResponder()
        
        self.service!.converse(self.dialogID!, conversationID:  self.conversationID!,
                               clientID: self.clientID!, input: textField.text!) { response, error in
                                let size = response?.response!.count
                                var i = 0
                                while (i<size) {
                                    //let ans = Int(arc4random_uniform(UInt32(size!)))
                                    if((response?.response![i])! != "") {
                                        //print("\(ans)> "+(response?.response![ans])!)
                                        //self.speak((response?.response![ans])!)
                                
                                        self.dialogLog.append((response?.response![i])!)
                                        print("Array: \(self.dialogLog)")
                                        break;
                                    }
                                    i+=1
                                }
                                
                                //reload tableview from main thread
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.DialogueTableView.reloadData()
                                }
        }

        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print("Cell count: \((self.dialogLog.count+1)/2)")
       print("Array: \(self.dialogLog)")
       return (self.dialogLog.count+1)/2
    }
    
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DialogueCell1") as! DialogueCell
        cell.myDialogueTextField.delegate = self
        print("Cell: \(indexPath.row) : Watson: \(self.dialogLog[2*indexPath.row])")
        cell.WatsonDialogueTextField.text = self.dialogLog[2*indexPath.row]
        if (2*indexPath.row+1 < self.dialogLog.count) {
            print("Cell: \(indexPath.row) : Answer: \(self.dialogLog[2*indexPath.row+1])")
            cell.myDialogueTextField.text = self.dialogLog[2*indexPath.row+1]
        } else {
            cell.myDialogueTextField.text = ""
        }
        
        cell.WatsonDialogueImage.image = UIImage(named: "watson.png")
        return cell
    }

    @IBAction func OnPressedEthnicity(sender: AnyObject) {
        
    }
    
}

    

   

