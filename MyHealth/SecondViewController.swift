//
//  SecondViewController.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 06/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//

import UIKit

/** This view for Reminder List to show all available notifications **/
class SecondViewController: UITableViewController {
    
    //holds number of events
    var todoItems: [TodoMedicineItem] = []

    // to ensure user receives any visual feedback that a notificatoon has fired 
    //when the app is running in the foreground.
    // and once the app resumes, the list must be refreshed automatically
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList", name: "TodoListShouldRefresh", object: nil)
         NSTimer.scheduledTimerWithTimeInterval(Constants.EXCERCISE_ALERT_FREQUENCY_in_sec, target: self, selector: #selector(SecondViewController.activateExcercise), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
      
    }
    
    func activateExcercise(){
        let currDate = NSDate()
        
        let notification:UILocalNotification = UILocalNotification()
        //trigger the notification after a while
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.category = "EXCERCISE_CATEGORY"
        notification.alertBody = "Excercise Done !!!"
        notification.fireDate = currDate
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    /** refresh the entire table list to update the new item
     
     Note :Limiting itto schedule 64 local notifications. If try to schedule
     more, the system will keep the 64 soonest firing notifications
     & automatically discard the rest
     **/
    func refreshList() {
        todoItems = TodoMedicineList.sharedInstance.allItems()
        //avoid running into issue by disallowing the creating of new items if 64 already exist
        if (todoItems.count >= 64) {
            self.navigationItem.rightBarButtonItem!.enabled = false // disable 'add' button
        }
        tableView.reloadData()
    }
    
    //defines number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //returns the number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath) // retrieve the prototype cell (subtitle style)
        let todoItem = todoItems[indexPath.row] as TodoMedicineItem
        
        cell.textLabel?.text = todoItem.title as String!
        if (todoItem.isOverdue) { // the current time is later than the to-do item's deadline
            cell.detailTextLabel?.textColor = UIColor.redColor()
        } else {
            cell.detailTextLabel?.textColor = UIColor.blackColor() // we need to reset this because a cell with red subtitle may be returned by dequeueReusableCellWithIdentifier:indexPath:
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a" // example: "Due Jan 01 at 12:00 PM"
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(todoItem.deadline)
        
        return cell
    }
    

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete { // the only editing style we'll support
            // Delete the row from the data source
            let item = todoItems.removeAtIndex(indexPath.row) // remove TodoItem from notifications array, assign removed item to 'item'
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            TodoMedicineList.sharedInstance.removeItem(item) // delete backing property list entry and unschedule local notification (if it still exists)
            self.navigationItem.rightBarButtonItem!.enabled = true // we definitely have under 64 notifications scheduled now, make sure 'add' button is enabled
        }
    }

    


}

