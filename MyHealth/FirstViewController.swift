//
//  FirstViewController.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 06/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//

import UIKit

/** ViewController for the first view to be displayed and register all required
  events **/

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Register notifications declared in AppDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"drawAShape:", name: "actionOnePressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"showAMessage:", name: "actionTwoPressed", object: nil)
        
        
        //This calls ensures to call the alert every x.0 seconds
        //This is reminder for call the heart rate every X seconds , so it can be configured to any value
        NSTimer.scheduledTimerWithTimeInterval(300.0, target: self, selector: Selector("triggerHeartRateNotification"), userInfo: nil, repeats: true)
        
    }
    
    
    //This will trigger Heart rate count to notify every time
    //so it will create a notification event on user mobile to start the heart rate count every x minute
    func triggerHeartRateNotification(){
        print("Trigger-------------")
        readHeartRate();
 //       createHeartRateStreamingQuery()
        let currDate = NSDate()
        
        let notification:UILocalNotification = UILocalNotification()
        //trigger the notification after a while
        notification.fireDate = NSDate(timeIntervalSinceNow: 20)
        notification.category = "FIRST_CATEGORY"
        notification.alertBody = "Heart rate Read"
        notification.fireDate = currDate
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    func readHeartRate(){
        
        let heartRate = defaults.doubleForKey("heartRate")
        print("READ THE VAKUE ",heartRate)
        if(heartRate > 60.0 || heartRate < 55.0){
            
            //reset the heart Rate value to not get triggered
             //defaults.setDouble(58.0, forKey: "heartRate")
             //defaults.synchronize()
            
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

