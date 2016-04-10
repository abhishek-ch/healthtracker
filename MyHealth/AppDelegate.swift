//
//  AppDelegate.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 06/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//
//

import UIKit
import HealthKit

/**

 Responsible for delegating entire Notification Action.
 
 
**/
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    // create reference of HKHealthStore to store health data to the application
    let healthStore = HKHealthStore()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        /** Action for Heart Rate Starts here**/
        // Actions
        
        //defines 3 different notifcation if the user crosses the time for taking the
        //medicine
        
    
        let firstAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = "FIRST_ACTION"
        firstAction.title = "Not Required"
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        //This action/notification will allow user to open the App
        let secondAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = "SECOND_ACTION"
        secondAction.title = "Open App"
        secondAction.activationMode = UIUserNotificationActivationMode.Background
        secondAction.destructive = false
        secondAction.authenticationRequired = false
        
        //This action will allow user to ignore the notification
        let thirdAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        thirdAction.identifier = "THIRD_ACTION"
        thirdAction.title = "Return Home"
        thirdAction.activationMode = UIUserNotificationActivationMode.Background
        thirdAction.destructive = false
        thirdAction.authenticationRequired = false
        
        
        // category for Heart rate
        /** It create category for c3 events to be triggered **/
        let firstCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "FIRST_CATEGORY"
        
        let defaultActions:NSArray = [firstAction, secondAction, thirdAction]
        let minimalActions:NSArray = [firstAction, secondAction]
        
        firstCategory.setActions(defaultActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        
        
        /** Defination of Reminder Action **/
        let completeAction = UIMutableUserNotificationAction()
        completeAction.identifier = "COMPLETE_TODO" // the unique identifier for this action
        completeAction.title = "Complete" // title for the action button
        completeAction.activationMode = .Background // UIUserNotificationActivationMode.Background - don't bring app to foreground
        completeAction.authenticationRequired = false // don't require unlocking before performing action
        completeAction.destructive = true // display action in red
        
        /** This will allow notification to pop up every 30 minutes in the user screen **/
        let remindAction = UIMutableUserNotificationAction()
        remindAction.identifier = "REMIND"
        remindAction.title = "Remind in 30 minutes"
        remindAction.activationMode = .Background
        remindAction.destructive = false
        
        /** Following wraps todo action ie either complete of remind after 30 minutes
         into a category
         **/
        let todoCategory = UIMutableUserNotificationCategory() // notification categories allow us to create groups of actions that we can associate with a notification
        todoCategory.identifier = "TODO_CATEGORY"
        todoCategory.setActions([remindAction, completeAction], forContext: .Default) // UIUserNotificationActionContext.Default (4 actions max)
        todoCategory.setActions([completeAction, remindAction], forContext: .Minimal) // UIUserNotificationActionContext.Minimal - for when space is limited (2 actions max)
        
        
        
        
        //Excercise Reminder
        /** Defination of Reminder Action **/
        let excerciseReminder = UIMutableUserNotificationAction()
        excerciseReminder.identifier = "EXCERCISE_DONE" // the unique identifier for this action
        excerciseReminder.title = "Complete" // title for the action button
        excerciseReminder.activationMode = .Background // UIUserNotificationActivationMode.Background - don't bring app to foreground
        excerciseReminder.authenticationRequired = false // don't require unlocking before performing action
        excerciseReminder.destructive = true // display action in red
        
        /** This will allow notification to pop up every 30 minutes in the user screen **/
        let remindActionAgain = UIMutableUserNotificationAction()
        remindActionAgain.identifier = "REMIND_DONE"
        remindActionAgain.title = "Remind in 30 minutes"
        remindActionAgain.activationMode = .Background
        remindActionAgain.destructive = false

        
        /** Following wraps todo action ie either complete of remind after 30 minutes
         into a category
         **/
        let excerciseCategory = UIMutableUserNotificationCategory() // notification categories allow us to create groups of actions that we can associate with a notification
        excerciseCategory.identifier = "EXCERCISE_CATEGORY"
        excerciseCategory.setActions([remindActionAgain, excerciseReminder], forContext: .Default) // UIUserNotificationActionContext.Default (4 actions max)
        excerciseCategory.setActions([excerciseReminder, remindActionAgain], forContext: .Minimal) // UIUserNotificationActionContext.Minimal - for when space is limited (2 actions max)
        
        
        
        

        // NSSet of all our categories
        
        let categories:NSSet = NSSet(objects: firstCategory,todoCategory,excerciseCategory)
        
        
        //establish notification
        //refer http://stackoverflow.com/questions/30761996/swift-2-0-binary-operator-cannot-be-applied-to-two-//uiusernotificationtype
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: categories as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)

        
        
        // Override point for customization after application launch.
        return true
    }
    
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: ([NSObject : AnyObject]?) -> Void) {
        if let value: AnyObject = userInfo?["scheduleLocalNotification"] where value as! Bool {
            let notification = UILocalNotification()
            notification.category = userInfo?["category"] as? String
            notification.alertTitle = userInfo?["alertTitle"] as? String
            notification.alertBody = userInfo?["alertBody"] as? String
            notification.fireDate = userInfo?["fireDate"] as? NSDate
            if let badge: AnyObject = userInfo?["applicationIconBadgeNumber"] {
                notification.applicationIconBadgeNumber = badge as! Int
            }
            notification.soundName = userInfo?["soundName"] as? String
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    
    // authorization from watch
    func applicationShouldRequestHealthAuthorization(application: UIApplication) {
        self.healthStore.handleAuthorizationForExtensionWithCompletion { success, error in
            
        }
    }
    
    func application(application: UIApplication,
        handleActionWithIdentifier identifier:String?,
        forLocalNotification notification:UILocalNotification,
        completionHandler: (() -> Void)){
            
        /** Following code refers to TodoMedicineItem and then based on switch case
             it post notifications to the user
             
             First -> actionOnePressed
             SECOND -> actionTwoPressed
             
             the completionHandler is called.
             **/
        
        print("notificationnotificationnotification ",notification)
        print("notification.userInfo! ",notification.userInfo)
        if notification.userInfo != nil {
            let item = TodoMedicineItem(deadline: notification.fireDate!, title: notification.userInfo!["title"] as! String, UUID: notification.userInfo!["UUID"] as! String!)
            
            
            switch (identifier!) {
            case "FIRST_ACTION":
                NSNotificationCenter.defaultCenter().postNotificationName("actionOnePressed", object: nil)
            case "SECOND_ACTION":
                NSNotificationCenter.defaultCenter().postNotificationName("actionTwoPressed", object: nil)
            case "COMPLETE_TODO":
                TodoMedicineList.sharedInstance.removeItem(item)
            case "REMIND":
                TodoMedicineList.sharedInstance.scheduleReminderforItem(item)
            default: // switch statements must be exhaustive - this condition should never be met
                print("Error: unexpected notification action identifier!")
            }
        }
        

      
        
     
        
            completionHandler()
            
    }
    
    //to refresh the Medicine Reminder list as soon as the view is active
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //Will prompt number of notifications pending
    // badging the app icon without using local notifications, it shows number of notifications
    //on the icon , it will be fired just before the user returns to the home screen where they can 
    //see the app icon
    
    //check @TodoMedicineList setBadgeNumbers
    
    func applicationWillResignActive(application: UIApplication) { // fired when user quits the application
        let todoItems: [TodoMedicineItem] = TodoMedicineList.sharedInstance.allItems() // retrieve list of all to-do items
        let overdueItems = todoItems.filter({ (todoItem) -> Bool in
            return todoItem.deadline.compare(NSDate()) != .OrderedDescending
        })
        UIApplication.sharedApplication().applicationIconBadgeNumber = overdueItems.count  // set our badge number to number of overdue items
    }


}

