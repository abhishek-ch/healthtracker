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

extension NSDate {
    var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(self)
    }
    
    var endOfDay: NSDate? {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: startOfDay, options: NSCalendarOptions())
    }
}

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
    let shareDate = DataSingleton.sharedInstance
    // Create a MessageComposer
    let messageComposer = MessageComposer()
    var defaultsGrp: NSUserDefaults = NSUserDefaults(suiteName: "group.com.myheart.health.MyHealth")!
    
    //Save the object values
    @IBAction func saveConfig(sender: AnyObject) {
        //sets the key for each field in the configuration
        saveDefaults()
    
    }
    
    func saveDefaults(){
 
        
        print("phoneTF.textphoneTF.text" ,phoneTF.text)
        defaultsGrp.setValue(nameTF.text, forKey: "name")
        defaultsGrp.setValue(phoneTF.text, forKey: "mainphone")
        shareDate.phoneName = nameTF.text!
        shareDate.phoneNumber = phoneTF.text!
        
        defaultsGrp.setValue(emergencyTF1.text, forKey: "emergency1")
        defaultsGrp.setValue(emergencyTF2.text, forKey: "emergency2")
        defaultsGrp.setValue(emergencyTF3.text, forKey: "emergency3")
        
//        defaultsGrp.setValue(81.0, forKey: "heartRateMain")
        defaultsGrp.synchronize()
        
        updateBasicDefaults()
        print("The value no>>>>>>w is=s> ",self.defaults.objectForKey("phoneTF"))
    }
    
    func updateBasicDefaults() {
        self.defaults.removeObjectForKey("nameTF")
        self.defaults.removeObjectForKey("phoneTF")
        self.defaults.removeObjectForKey("emergencyTF1")
        self.defaults.removeObjectForKey("emergencyTF2")
        self.defaults.removeObjectForKey("emergencyTF3")
        

        self.defaults.setValue(nameTF.text, forKey: "nameTF")
        self.defaults.setValue(phoneTF.text, forKey: "phoneTF")
        self.defaults.setValue(emergencyTF1.text, forKey: "emergencyTF1")
        self.defaults.setValue(emergencyTF2.text, forKey: "emergencyTF2")
        self.defaults.setValue(emergencyTF3.text, forKey: "emergencyTF3")
        
        self.defaults.synchronize()
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
    
    
    
    
    
    

    

    //TODO close
    @IBAction func cancelConfig(sender: AnyObject) {
        
    } 
    
    
    
let healthStore: HKHealthStore = HKHealthStore()
    
    func query(){
        let dataTypesToRead = NSSet(objects: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!)
        
        healthStore.requestAuthorizationToShareTypes(nil, readTypes: dataTypesToRead as! Set<HKObjectType>, completion: { [unowned self] (success, error) in
            if success {
                let stepsCount = HKQuantityType.quantityTypeForIdentifier(
                    HKQuantityTypeIdentifierStepCount)
                let sumOption = HKStatisticsOptions.CumulativeSum
                
                let statisticsSumQuery = HKStatisticsQuery(quantityType: stepsCount!, quantitySamplePredicate: nil,
                    options: sumOption)
                { [unowned self] (query, result, error) in
                    if let sumQuantity = result?.sumQuantity() {
                        let numberOfSteps = Int(sumQuantity.doubleValueForUnit(HKUnit.countUnit()))
                        print("numberOfStepsnumberOfStepsnumberOfSteps ->> ",numberOfSteps)
                        NSLog("numberOfStepsnumberOfSteps%d", numberOfSteps)
                        
                    }
                    //            self.activityIndicator.stopAnimating()
                    
                }
                
                // Don't forget to execute the query!
                self.healthStore.executeQuery(statisticsSumQuery)
            } else {
                print("hsacbhjasbcbahjbshj")
            }
            })
        
        
  
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
    

    

    
    
    //refer http://stackoverflow.com/questions/27642492/saving-and-loading-an-integer-on-xcode-swift
    //load default values once you launch the App
    func loadDefaultValues(){
        
//        if let mainphone = defaultsGrp.valueForKey("name"){
//            nameTF?.text = mainphone as? String
//        }
//        if let mainphone = defaultsGrp.valueForKey("mainphone"){
//            phoneTF?.text = mainphone as? String
//        }
//        if let mainphone = defaultsGrp.valueForKey("emergency1"){
//            emergencyTF1?.text = mainphone as? String
//        }
//        if let mainphone = defaultsGrp.valueForKey("emergency1"){
//            emergencyTF2?.text = mainphone as? String
//        }
//        if let mainphone = defaultsGrp.valueForKey("emergency1"){
//            emergencyTF3?.text = mainphone as? String
//        }
        
        self.loadBasicValues()
        saveDefaults()
        
    }
    
    func loadBasicValues() {
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
//            completionHandler(accessGranted: true)
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
