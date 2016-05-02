import UIKit
import WatsonDeveloperCloud
import AVFoundation
import CoreLocation

class DialogueViewController: UIViewController, UITableViewDelegate, AVAudioRecorderDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate {
    
//Mark: Outlets
    @IBOutlet weak var onSendButtonPressed: UIButton!
    @IBOutlet weak var DialogueTableView: UITableView!
    @IBOutlet weak var spacerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var responseTextField: UITextField!
    
//Mark: variables/constants
    var conversationID: Int?
    var clientID: Int?
    var service: Dialog?
    var tts: TextToSpeech?
    var dialogID: Dialog.DialogID?
    var watsonLog: [String] = []
    var userLog: [String] = []
    var foodType = "food"
    var dist = String()
    var currentLocation: String?
    
    let newLocationManger = CLLocationManager()
    
//MARK: View Load/Appear Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        newLocationManger.delegate = self
        newLocationManger.requestLocation()
        
        self.DialogueTableView.separatorStyle = .None
        self.responseTextField.delegate = self
        self.onSendButtonPressed.enabled = false
        
        self.service = Dialog(username: "b9b42757-5fa9-4633-8cb6-39f92fe7e18c", password: "GiDY7J5THqx3")
        self.tts = TextToSpeech(username: "68d797f2-38cb-4c4f-b743-f07e4a928280", password: "KTGQijyQ21M1")
        
        
        let dialogName = "xmlchanged20"
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
        
        let path = NSBundle.mainBundle().pathForResource("foodSearchDialog-8", ofType: "xml")
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }

//Mark: Location Manager
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if location?.verticalAccuracy < 1000 && location?.horizontalAccuracy < 1000 {
            reverseGeoCode(location!)
        }
    }
    
    func reverseGeoCode(location: CLLocation) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { (placemark, error) in
            let placemark = placemark?.first
            self.currentLocation = "\(placemark!.subThoroughfare!) \(placemark!.thoroughfare!) \(placemark!.locality!), \(placemark!.administrativeArea!)"
            print("Location detected: \(self.currentLocation!)")
        }
    }

//MARK: Tableview Scroll
    func tableViewScrollToTop(animated: Bool) {
        dispatch_after(0, dispatch_get_main_queue(), {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.DialogueTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: animated)
        })
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
    
//MARK: Watson Dialog and Text-to-Speech
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
                } catch {
                    NSLog("Bad sound data")
                }
            } else {
                print(error)
            }
        }
    }
    
    
    func parse(text: String)-> Void {
        let keywords = [ "dim sum", "chinese", "vietnamese", "american", "italian", "french", "korean", "japanese", "thai", "mexican", "peruvian", "british", "mongolian", "taiwanese", "bbq", "greek", "taco", "tacos", "sushi", "burgers", "pasta", "kbbq", "breakfast", "brunch", "souvlaki"]
        let distances = [ "2 block", "6 blocks", "1 mile", "5 miles", "20 miles"]
        for word in keywords {
            if text.lowercaseString.rangeOfString(word) != nil {
                foodType = word
/*
                switch(word) {
                case "dim sum":
                    foodType = "chinese"
                    break
                case "sushi":
                    foodType = "japanese"
                    break
                default:
                    break
                }
 */
            }
        }
        for word in distances {
            if text.rangeOfString(word) != nil {
                dist = word
            }
        }
        
        
    }
    
    func responseFromUser(text: String?) -> Bool {
        if(text == nil || text! == "") {
            return false
        }
        self.userLog.append(text!)
        
        if((text == "Done") || (text == "done") || (text == "Done!") || (text == "done!")) {
            if (self.currentLocation == nil) {
                let alert = UIAlertController(title: "Alert", message: "You must enable location services to get search results", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                performSegueWithIdentifier("SearchSegue", sender: self)
            }
        }
        parse(text!)
        
        self.service!.converse(self.dialogID!, conversationID:  self.conversationID!,
                               clientID: self.clientID!, input: text!) { response, error in
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
    
//MARK: TableView Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watsonLog.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DialogueCell1") as! DialogueCell
        cell.WatsonDialogueTextField.text = self.watsonLog[indexPath.row]
        if (indexPath.row < self.userLog.count) {
            cell.myDialogueTextField.text = self.userLog[indexPath.row]
        } else {
            cell.myDialogueTextField.text = ""
        }
        
        cell.WatsonDialogueTextField.font = UIFont(name: "Palatino", size: 16)
        cell.WatsonDialogueImage.image = UIImage(named: "Satellites-100.png")
        return cell
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotificationUpdateKeyboard(notification)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotificationUpdateKeyboard(notification)
    }
    
    func updateBottomLayoutConstraintWithNotificationUpdateKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntValue << 16
        let animationCurve = UIViewAnimationOptions(rawValue: (UInt(rawAnimationCurve)|UInt(1<<2)))
        
        spacerBottomConstraint.constant = CGRectGetMinY(convertedKeyboardEndFrame)-CGRectGetMaxY(view.bounds)
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: animationCurve, animations: {
            self.view.layoutIfNeeded()
            }, completion: { finished in
                self.tableViewScrollToBottom(true)
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.text == nil || textField.text! == "") {
            return false
        }
        self.responseFromUser(responseTextField.text)
        responseTextField.text = ""
        return true
    }
    
//MARK: IBAction outlets
    @IBAction func textFieldIsEditing(sender: UITextField) {
        if sender.text == nil || sender.text == "" {
            self.onSendButtonPressed.enabled = false
        } else {
            self.onSendButtonPressed.enabled = true
        }
    }
    
    @IBAction func onSendButtonPressed(sender: AnyObject) {
        self.responseFromUser(responseTextField.text)
        responseTextField.text = ""
    }
    
    @IBAction func onMuteButtonPressed(sender: UIButton) {
        let unmuteIcon = UIImage(named: "High Volume-30")
        let muteIcon = UIImage(named: "Mute-30")
        
        if (sender.imageView?.image == unmuteIcon) {
            sender.setImage(muteIcon, forState: UIControlState.Normal)
            print("Mute")
        } else {
            sender.setImage(unmuteIcon, forState: UIControlState.Normal)
            print("Unmute")
        }
    }
    
    
//MARK: PrepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let srvc = segue.destinationViewController as! SearchResultViewController
        srvc.distance = dist
        srvc.searchTerm = foodType
        srvc.locationFromWatson = self.currentLocation!
    }
}