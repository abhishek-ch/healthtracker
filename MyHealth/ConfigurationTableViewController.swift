//
//  ConfigurationTableViewController.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 16/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI
import HealthKit

class ConfigurationTableViewController: UITableViewController,CNContactPickerDelegate,MFMessageComposeViewControllerDelegate {
    
    
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addNameBtn: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    
    
    @IBOutlet weak var emergencyTF1: UITextField!
    @IBOutlet weak var emergencyTF2: UITextField!
    @IBOutlet weak var emergencyTF3: UITextField!
    
    
    @IBOutlet weak var emailTF1: UITextField!
    @IBOutlet weak var emailTF2: UITextField!
    @IBOutlet weak var emailTF3: UITextField!
    @IBOutlet weak var emailTF4: UITextField!
    
        var emergencyStatus1 = false
        var emergencyStatus2 = false
        var emergencyStatus3 = false
    
    var addNameStatus = false
    
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    //Save the object values
    @IBAction func saveConfig(sender: AnyObject) {
        //sets the key for each field in the configuration
     
        defaults.removeObjectForKey("nameTF")
        defaults.removeObjectForKey("phoneTF")
        defaults.removeObjectForKey("emergencyTF1")
        defaults.removeObjectForKey("emergencyTF2")
        defaults.removeObjectForKey("emergencyTF3")
        
        defaults.setObject(nameTF.text, forKey: "nameTF")
        defaults.setObject(phoneTF.text, forKey: "phoneTF")
        defaults.setObject(emergencyTF1.text, forKey: "emergencyTF1")
        defaults.setObject(emergencyTF2.text, forKey: "emergencyTF2")
        defaults.setObject(emergencyTF3.text, forKey: "emergencyTF3")
        
        defaults.synchronize()
    }
    
    
    @IBAction func addPhoneAction(sender: AnyObject) {
        addNameStatus = true
       self.showContactPickerController()
        
    }
    
    @IBAction func addName(sender: AnyObject) {
        addNameStatus = true
        self.showContactPickerController()

    }
    
    @IBAction func emergencyBtn1(sender: AnyObject) {
        emergencyStatus1 = true
        self.showContactPickerController()
    }
    
    @IBAction func emergencyBtn2(sender: AnyObject) {
        emergencyStatus2 = true
        self.showContactPickerController()
    }
    
    @IBAction func emergencyBtn3(sender: AnyObject) {
        emergencyStatus3 = true
        self.showContactPickerController()
    }
    
    
    
    
    
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(textMessageRecipients:[String] ,textBody body:String) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body = body
        return messageComposeVC
    }
    
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = ["1-800-867-5309"]
        messageComposeVC.body = "Hey friend - Just sending a text message in-app using Swift!"
        return messageComposeVC
    }
    
    // Create a MessageComposer
    let messageComposer = MessageComposer()
    
    //TODO close
    @IBAction func cancelConfig(sender: AnyObject) {
        print("Cancel " ,MFMessageComposeViewController.canSendText())
        
        
        
        
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            presentViewController(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
        
        
       // navigationController?.popToRootViewControllerAnimated(true)
       // self.dismissViewControllerAnimated(true, completion: nil)
//        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        let phoneNumberArray = ["(415) 555-4387"]
//        let userNumber = "(415) 555-4387"
//        if (MFMessageComposeViewController.canSendText()) {
//            print("MESSAGE Controller")
//            let controller = MFMessageComposeViewController()
//            controller.body = "This Boy is not Taking medicine on Time"
//            controller.recipients = ["(415) 555-4387"]
//            controller.messageComposeDelegate = self
//            self.presentViewController(controller, animated: true, completion: nil)
//        }else{
//            print("Can't Send Message")
//            //UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(userNumber)")!)
//            UIApplication.sharedApplication().openURL(NSURL(string: "tel://9809088798")!)
//            callNumber("7178881234")
//           }
        
    }

    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL)
            }
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    
    @IBOutlet weak var addPhoneBtn: NSLayoutConstraint!
    
    private var store: CNContactStore!
    private var menuArray: NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDefaultValues()

        print("LOAD THE VALUES ")
        //read the heart rate
        //NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: Selector("readHeartRate"), userInfo: nil, repeats: true)
     
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        store = CNContactStore()
        authorizeAddressBookAddress()
        
    }
    

    
    //This method reads the heart rate every x seconds and ensure that it doesn't crosses the
    //limit and if it does, as of now it throws an alert to the user
    //can be made to call user once the call api works properly
    func readHeartRate(){
     
        let heartRate = self.defaults.doubleForKey("heartRate")
        print("READ THE VAKUE ",heartRate)
        if(heartRate > 60.0 || heartRate < 55.0){
            
            //reset the heart Rate value to not get triggered
            // self.defaults.setDouble(58.0, forKey: "heartRate")
            // self.defaults.synchronize()
            
            let currDate = NSDate()
            
            let notification:UILocalNotification = UILocalNotification()
            //trigger the notification after a while
            notification.fireDate = NSDate(timeIntervalSinceNow: 20)
            notification.category = "HEART_RATE_ALERT"
            notification.alertBody = "Heart Rate Warning!!!"
            notification.fireDate = currDate
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
 
        }
  
    }
    
    
    //refer http://stackoverflow.com/questions/27642492/saving-and-loading-an-integer-on-xcode-swift
    //load default values once you launch the App
    func loadDefaultValues(){
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        nameTF?.text = defaults.valueForKey("nameTF") as? String
        phoneTF?.text = defaults.valueForKey("phoneTF") as? String
        
        emergencyTF1?.text = defaults.valueForKey("emergencyTF1") as? String
        emergencyTF2?.text = defaults.valueForKey("emergencyTF2") as? String
        emergencyTF3?.text = defaults.valueForKey("emergencyTF3") as? String
    }
    
    func authorizeAddressBookAddress(){
        

        
        
        switch CNContactStore.authorizationStatusForEntityType(.Contacts){
        case .Authorized:
            print("Authorized")
            //completionHandler(accessGranted: true)
        case .NotDetermined:
            print("Not Determined")
            self.requestContactsAccess()
        default:
            print("Not handled")
        }
    }
    
    /*
        request Contact Access if its not determined.
    The access can be provided using grant access
    */
    private func requestContactsAccess() {
        
        store.requestAccessForEntityType(.Contacts) {granted, error in
            if granted {
                dispatch_async(dispatch_get_main_queue()) {
                   // self.accessGrantedForContacts()
                    return
                }
            }
        }
    }
    
    
    //MARK: Show all contacts
    // Called when users tap "Display Picker" in the application. Displays a list of contacts and allows users to select a contact from that list.
    // The application only shows the phone, email, and birthdate information of the selected contact.
    private func showContactPickerController() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactGivenNameKey]
        
        self.presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        let contact = contactProperty.contact
        //set the Phone Number in first column
        if let phoneNumber = contactProperty.value as? CNPhoneNumber
        {
            if addNameStatus
            {
                print(phoneNumber.stringValue)
                phoneTF?.text = phoneNumber.stringValue
                print(contact.givenName)
                nameTF?.text = contact.givenName
                addNameStatus = false
                
            }else if emergencyStatus1{
                emergencyTF1?.text = phoneNumber.stringValue
                emergencyStatus1 = false
            }else if emergencyStatus2{
                emergencyTF2?.text = phoneNumber.stringValue
                emergencyStatus2 = false
            }else if emergencyStatus3{
                emergencyTF3?.text = phoneNumber.stringValue
                emergencyStatus3 = false
            }
            
        }
    


 
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Implement this if you want to do additional work when the picker is cancelled by the user.
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        picker.dismissViewControllerAnimated(true, completion: {})
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        //... handle sms screen actions
       // self.dismissViewControllerAnimated(true, completion: nil)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
