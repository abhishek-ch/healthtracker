//
//  TodoMedicineList.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 07/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//

import Foundation
import UIKit

class TodoMedicineList{
    
    
    private let ITEMS_KEY = "todoItems"
    
    //Single Instance
    class var sharedInstance : TodoMedicineList {
        struct Static {
            static let instance : TodoMedicineList = TodoMedicineList()
        }
        return Static.instance
    }
    
    func allItems() -> [TodoMedicineItem] {
        let todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map({TodoMedicineItem(deadline: $0["deadline"] as! NSDate, title: $0["title"] as! String, UUID: $0["UUID"] as! String!)}).sort({(left: TodoMedicineItem, right:TodoMedicineItem) -> Bool in
            (left.deadline.compare(right.deadline) == .OrderedAscending)
        })
    }
    
    /** persisting our items to the memory **/
    func addItem(item: TodoMedicineItem) {
        
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Todo Item \"\(item.title)\" Is Overdue" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        
        //https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/index.html#//apple_ref/doc/uid/TP40001451-SW2
        
        //notification.repeatInterval = NSCalendarUnit.Day
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        //notification.repeatInterval = NSCalendarUnit.
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        //update the badge on adding new item
        self.setBadgeNumbers()
        
        
        
        
    }
    
    /** clear out complreted items from the list 
     since we need to remove the existing notification , so we need to retreive the old one
     and cancel the same before scheduling
     **/
    func removeItem(item: TodoMedicineItem) {
        for notification in (UIApplication.sharedApplication().scheduledLocalNotifications )! { // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
        }
        
        if var todoItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
            todoItems.removeValueForKey(item.UUID)
            NSUserDefaults.standardUserDefaults().setObject(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
        //update the badge on removing item
        self.setBadgeNumbers()
    }
    
    //promt user with re-reminder after X number of minutes
    func scheduleReminderforItem(item: TodoMedicineItem) {
        let notification = UILocalNotification() // create a new reminder notification
        notification.alertBody = "Medicine Intake\"\(item.title)\" Is Overdue" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate().dateByAddingTimeInterval(30 * 60) // 30 minutes from current time
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification that we can use to retrieve it later
        notification.category = "TODO_CATEGORY"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    /** after App Delegate is activated the way to show the badges, here the badge number to schedule to
     update automatically where todo items become overdue.
     
     We can’t instruct the app to simply increment the badge value when our notifications fire, 
     but we can pre-compute and provide a value for the “applicationIconBadgeNumber” property of our local notifications     
     **/
    func setBadgeNumbers() {
       // var notifications = UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] // all scheduled notifications
        let todoItems: [TodoMedicineItem] = self.allItems()
        for notification in (UIApplication.sharedApplication().scheduledLocalNotifications )! {
            let overdueItems = todoItems.filter({ (todoItem) -> Bool in // array of to-do items...
                return (todoItem.deadline.compare(notification.fireDate!) != .OrderedDescending) // ...where item deadline is before or on notification fire date
            })
            UIApplication.sharedApplication().cancelLocalNotification(notification) // cancel old notification
            notification.applicationIconBadgeNumber = overdueItems.count // set new badge number
            UIApplication.sharedApplication().scheduleLocalNotification(notification) // reschedule notification
        }
    }
    
}