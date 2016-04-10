//
//  FirstViewController.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 06/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//

import UIKit
import HealthKit

/** ViewController for the first view to be displayed and register all required
 events **/

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Register notifications declared in AppDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(FirstViewController.drawAShape(_:)), name: "actionOnePressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"showAMessage:", name: "actionTwoPressed", object: nil)
        
        
        //         NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(FirstViewController.phoneNotificationHandler), userInfo: nil, repeats: true)
        //This calls ensures to call the alert every x.0 seconds
        //This is reminder for call the heart rate every X seconds , so it can be configured to any value
        NSTimer.scheduledTimerWithTimeInterval(Constants.HEART_COUNT_FREQUENCY_in_sec, target: self, selector: #selector(FirstViewController.triggerHeartRateNotification), userInfo: nil, repeats: true)
        
        
        
    }
    
    
    let healthStore: HKHealthStore = HKHealthStore()
    
    // Create a MessageComposer
    let messageComposer = MessageComposer()
    let defaultsGrp = NSUserDefaults(suiteName: "group.com.myheart.health.MyHealth")
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var heartRateCrossed: Bool = true
    //Main function to examine heart Rate counts
    //if it crosses certain level it triggers user interactions
    func fetchHeartRates() -> Bool{
        let startTime: NSDate = NSDate()
        // First moment of a given date
        let startOfDay = NSCalendar.currentCalendar().startOfDayForDate(startTime)
        
        // Components to calculate end of day
        let components = NSDateComponents()
        components.minute = -10
        
        // Last moment of a given date
        let endTime = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: startOfDay, options: NSCalendarOptions())
        
        
        print("StartTime => ",startTime)
        print("NEDD TIME ==> ", endTime)
        
        
        
   
        
        let sampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let predicate = HKQuery.predicateForSamplesWithStartDate(endTime, endDate: startTime, options: HKQueryOptions.None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: 100, sortDescriptors: [sortDescriptor])
        { (query, results, error) in
            if error != nil {
                print("An error has occured with the following description: \(error!.localizedDescription)")
            } else {
                for r in results!{
                    let result = r as! HKQuantitySample
                    let quantity = result.quantity
                    let count = quantity.doubleValueForUnit(HKUnit(fromString: "count/min"))
                    print("Heart rate Data: \(count) : \(result)")
                    if count > Constants.MAXIMUM_HEART_RATE || count < Constants.MINIMUM_HEART_RATE{
                        self.heartRateCrossed = false
                        break
                    }
                   
                }
            }
        }
        healthStore.executeQuery(query)
        return self.heartRateCrossed
        
    }
    
    
    //This method reads the heart rate every x seconds and ensure that it doesn't crosses the
    //limit and if it does, as of now it throws an alert to the user
    //can be made to call user once the call api works properly
    func triggerHeartRateWarningAlert(){

            let currDate = NSDate()
            
            let notification:UILocalNotification = UILocalNotification()
            //trigger the notification after a while
            notification.fireDate = NSDate(timeIntervalSinceNow: 2)
            notification.category = "HEART_RATE_ALERT"
            notification.alertBody = "Heart Rate Warning!!!"
            notification.fireDate = currDate
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    
    func makeACall(){
        let mainphone = shareDate.getPhoneNumber()
        print("PhoneToMakeCall ",mainphone)
        let url:NSURL = NSURL(string: "tel://"+(mainphone))!
        UIApplication.sharedApplication().openURL(url)
        
        
    }
    
    
    func phoneNotificationHandler(){
        let mainphone = shareDate.getPhoneNumber()
            print("Phoine To send Text ",mainphone)
            // Make sure the device can send text messages
            if (messageComposer.canSendText()) {
                // Obtain a configured MFMessageComposeViewController
                let messageComposeVC = messageComposer.configuredMessageComposeViewController([mainphone])
                
                // Present the configured MFMessageComposeViewController instance
                // Note that the dismissal of the VC will be handled by the messageComposer instance,
                // since it implements the appropriate delegate call-back
                presentViewController(messageComposeVC, animated: true, completion: nil)
            } else {
                // Let the user know if his/her device isn't able to send text messages
                let errorAlert = UIAlertView(title: "Unsupported Device", message: "Device doesnt support text message", delegate: self, cancelButtonTitle: "OK")
                errorAlert.show()
            }
        
    
       
        
        
    }
    
    //This will trigger Heart rate count to notify every time
    //so it will create a notification event on user mobile to start the heart rate count every x minute
    func triggerHeartRateNotification(){
        
        let heartRateCrossedLimit : Bool = fetchHeartRates()

        if heartRateCrossedLimit {
            let currDate = NSDate()
            
            let notification:UILocalNotification = UILocalNotification()
            //trigger the notification after a while
            notification.fireDate = NSDate(timeIntervalSinceNow: 5)
            notification.category = "FIRST_CATEGORY"
            notification.alertBody = "Heart Rate reminder"
            notification.fireDate = currDate
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        } else{
            self.showAlertMessageOnCrossingHeartRate()
         
        }
     

        
    }
    
    

    
    func showAlertMessageOnCrossingHeartRate(){
        // create the alert
        let alert = UIAlertController(title: "Heart Rate Warning", message: "Heart rate doesn't seem good, Sending Text messages to emergency contacts, Reset HeartRate in healthKit", preferredStyle: UIAlertControllerStyle.Alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            // Phone Notification
            self.phoneNotificationHandler()
            self.makeACall()
        }))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    let shareDate = DataSingleton.sharedInstance
    var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    

    /** shape to show the view **/
    func drawAShape(notification:NSNotification){
        let view:UIView = UIView(frame:CGRectMake(10, 10, 100, 100))
        view.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(view)
        
    }
    
    /** notification message to show**/
    func showAMessage(notification:NSNotification){
        let message:UIAlertController = UIAlertController(title: "A Notification Message", message: "Press Action or...", preferredStyle: UIAlertControllerStyle.Alert)
        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(message, animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

