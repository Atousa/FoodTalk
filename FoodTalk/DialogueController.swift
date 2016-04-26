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

class DialogueViewController: UIViewController,UITableViewDelegate,UITextFieldDelegate, AVAudioRecorderDelegate,UITableViewDataSource {
    

    @IBOutlet weak var DialogueTableView: UITableView!
    
    var conversationID: Int?
    var clientID: Int?
    var service: Dialog?
    var tts: TextToSpeech?
    var dialogID: Dialog.DialogID?
    var watsonLog: [String] = []
    var userLog: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DialogueTableView.separatorStyle = .None
        
        self.service = Dialog(username: "585c94ca-d7e2-4b6e-9b8c-e28e00d27b55", password: "keuvuyZjRb7O")
        self.tts = TextToSpeech(username: "68d797f2-38cb-4c4f-b743-f07e4a928280", password: "KTGQijyQ21M1")
        
        
        let dialogName = "xmlchanged1"
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

    func tableViewScrollToBottom(animated: Bool) {
        let delay = 0 //0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.DialogueTableView.numberOfSections
            let numberOfRows = self.DialogueTableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.DialogueTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
        })
    }

    func startDialogue() {
        self.service!.converse(self.dialogID!) { response, error in
            if error != nil {
                print(error?.userInfo)
                return
            }
            self.conversationID = response?.conversationID
            self.clientID = response?.clientID
            self.watsonLog.append((response?.response![0])!)
            self.speak((response?.response![0])!)

            //reload tableview from main thread
            dispatch_async(dispatch_get_main_queue()) {
                self.DialogueTableView.reloadData()
            }
        }
    }
    
    func speak(text: String) {
        self.tts!.synthesize(text) {
            data, error in
            if let data = data {
               do {
                    let audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    sleep(UInt32(audioPlayer.duration+1))
                    print("foo!")
                } catch {
                    NSLog("Bad sound data")
                }
            } else {
                print(error)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.text == nil || textField.text! == "") {
            return false
        }
        self.userLog.append(textField.text!)
        textField.enabled = false
        resignFirstResponder()
        
        self.service!.converse(self.dialogID!, conversationID:  self.conversationID!,
                               clientID: self.clientID!, input: textField.text!) { response, error in
                                let size = response?.response!.count
                                var i = 0
                                while (i<size) {
                                    //let ans = Int(arc4random_uniform(UInt32(size!)))
                                    if((response?.response![i])! != "") {
                                        //print("\(ans)> "+(response?.response![ans])!)
                                        self.speak((response?.response![i])!)
                                        self.watsonLog.append((response?.response![i])!)
                                        break;
                                    }
                                    i+=1
                                }
                                
                                //reload tableview from main thread
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.DialogueTableView.reloadData()
                                    self.tableViewScrollToBottom(true)
                                }
        }

        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.watsonLog.count
    }
    
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    
        let cell = tableView.dequeueReusableCellWithIdentifier("DialogueCell1") as! DialogueCell
        cell.myDialogueTextField.delegate = self
        cell.WatsonDialogueTextField.text = self.watsonLog[indexPath.row]
        cell.myDialogueTextField.enabled = true
        if (indexPath.row < self.userLog.count) {
            cell.myDialogueTextField.text = self.userLog[indexPath.row]
        } else {
            cell.myDialogueTextField.text = ""
        }
        
        cell.WatsonDialogueImage.image = UIImage(named: "watson.png")
        return cell
    }
    

   // @IBAction func OnPressedEthnicity(sender: AnyObject) {
        //let svc = UIViewController()
        //sev.... = userlog
        
   // }
    
}

    

   

