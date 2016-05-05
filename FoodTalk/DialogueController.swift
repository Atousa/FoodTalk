import UIKit
import WatsonDeveloperCloud
import AVFoundation
import CoreLocation

class DialogueViewController: UIViewController, UITableViewDelegate, AVAudioRecorderDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate {
    
//Mark: Outlets
    @IBOutlet weak var onSendButtonPressed: UIButton!
    @IBOutlet weak var dialogueTableView: UITableView!
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
    var location: CLLocation?
    var locationAddress: String?
    var maxHeight:CGFloat?
    var activityIndicator = UIActivityIndicatorView()
    

//MARK: View Load/Appear Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Watson"

        self.addActivityIndicator()
//        let giphyButton = UIBarButtonItem.init(title: "Giphy", style: UIBarButtonItemStyle.Plain, target: self, action:Selector("Say This"))
//        self.navigationItem.rightBarButtonItem = giphyButton
        self.activityIndicator.startAnimating()
        
        self.dialogueTableView.separatorStyle = .None
        self.responseTextField.delegate = self
        self.onSendButtonPressed.enabled = false
        
        self.service = Dialog(username: "b9b42757-5fa9-4633-8cb6-39f92fe7e18c", password: "GiDY7J5THqx3")
        self.tts = TextToSpeech(username: "68d797f2-38cb-4c4f-b743-f07e4a928280", password: "KTGQijyQ21M1")
        
        
        let dialogName = "xmlchanged38"

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
        
        let path = NSBundle.mainBundle().pathForResource("foodSearchDialog", ofType: "xml")
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


//MARK: Tableview Scroll
    func tableViewScrollToTop(animated: Bool) {
        dispatch_after(0, dispatch_get_main_queue(), {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.dialogueTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: animated)
        })
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        let delay = 0 //0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.dialogueTableView.numberOfSections
            let numberOfRows = self.dialogueTableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.dialogueTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
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
            dispatch_async(dispatch_get_main_queue()) {
                self.dialogueTableView.reloadData()
                self.activityIndicator.stopAnimating()
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
        let keywords = [ "american",
                         "bbq",
                         "breakfast",
                         "brunch",
                         "british",
                         "burgers",
                         "chinese",
                         "dim sum",
                         "food truck",
                         "french",
                         "greek",
                         "indian",
                         "italian",
                         "japanese",
                         "korean",
                         "mediterranean",
                         "mexican",
                         "mongolian",
                         "pasta",
                         "peruvian",
                         "pizza",
                         "souvlaki",
                         "sushi",
                         "taco",
                         "taiwanese",
                         "thai",
                         "vegan",
                         "vegetarian",
                         "vietnamese" ]
        let distances = [ "2 block", "6 blocks", "1 mile", "5 miles", "20 miles"]
        for word in keywords {
            if text.lowercaseString.rangeOfString(word) != nil {
                foodType = word
            }
        }
        for word in distances {
            if text.rangeOfString(word) != nil {
                dist = word
            }
        }
    }
    
    func responseFromUser(text: String?) -> Bool {
        self.activityIndicator.startAnimating()
        if(text == nil || text! == "") {
            return false
        }
        self.userLog.append(text!)
        
        if((text == "Done") || (text == "done") || (text == "Done!") || (text == "done!")) {
            performSegueWithIdentifier("SearchSegue", sender: self)
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
                                    self.dialogueTableView.reloadData()
                                    self.tableViewScrollToBottom(true)
                                    self.activityIndicator.stopAnimating()
                                }
        }
        
        return true
    }
    
    func addActivityIndicator(){
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,40,40))
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.activityIndicator.center = self.view.center
        self.view.addSubview(self.activityIndicator)
    }
    
//MARK: TableView Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watsonLog.count
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 150
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DialogueCell1") as! DialogueCell
        
        cell.WatsonDialogueTextField.text = self.watsonLog[indexPath.row]
        if (indexPath.row < self.userLog.count) {
            cell.myDialogueTextField.text = self.userLog[indexPath.row]
        } else {
            cell.myDialogueTextField.text = ""
        }
        
        cell.WatsonDialogueTextField.sizeToFit()
        cell.myDialogueTextField.sizeToFit()
        
        cell.WatsonDialogueTextField.font = UIFont(name: "Palatino", size: 16)
        cell.myDialogueTextField.font = UIFont(name: "Palatino", size: 16)
        cell.WatsonDialogueImage.image = UIImage(named: "Satellites-100.png")
        cell.userDialogueImage.image = UIImage(named: "Cool-100")
        return cell
    }
    
    
//MARK: Keyboard and layout methods
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
    
    
    
//MARK: TextField Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.text == nil || textField.text! == "") {
            return false
        }
        self.responseFromUser(responseTextField.text)
        responseTextField.text = ""
        return true
    }
    
//    Limits the characters a user can type in the response field
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = self.responseTextField.text?.characters.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 40
    }
    
    

    @IBAction func textFieldIsEditing(sender: UITextField) {
        if sender.text == nil || sender.text == "" {
            self.onSendButtonPressed.enabled = false
        } else {
            self.onSendButtonPressed.enabled = true
        }
        
        
    }
    
//MARK: Button methods
    @IBAction func onSendButtonPressed(sender: AnyObject) {
        self.responseFromUser(responseTextField.text)
        responseTextField.text = ""
    }
    
    @IBAction func onMuteButtonPressed(sender: UIButton) {
        self.tts = TextToSpeech(username: "68d797f2", password: "KTGQ")
        let unmuteIcon = UIImage(named: "High Volume-30")
        let muteIcon = UIImage(named: "Mute-30")
        
        if (sender.imageView?.image == unmuteIcon) {
            sender.setImage(muteIcon, forState: UIControlState.Normal)
            
        } else {
            
            sender.setImage(unmuteIcon, forState: UIControlState.Normal)
             self.tts = TextToSpeech(username: "68d797f2-38cb-4c4f-b743-f07e4a928280", password: "KTGQijyQ21M1")
        }
    }

//MARK: PrepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let srvc = segue.destinationViewController as! SearchResultViewController
        srvc.distance = dist
        srvc.searchTerm = foodType
        srvc.location = self.location
        srvc.locationAddress = self.locationAddress
    }
}