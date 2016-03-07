//
//  MedicineInputTableViewController.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 12/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//

import UIKit

/** Medicine input controller to handle any medicine entry to the ui **/
class MedicineInputTableViewController: UITableViewController {

    @IBOutlet weak var startLabel: UILabel!
    
    
    @IBOutlet weak var startDate: UIDatePicker!
    
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var titleField: UITextField!

    @IBOutlet weak var endDateDetail: UILabel!
    
    
    @IBOutlet weak var repeatLbl: UILabel!
    
    var repeatSelectedValue:String! = "Never"
    
    
    //Save the medicine add content
    @IBAction func saveMedAlert(sender: AnyObject) {
        
        let todoItem = TodoMedicineItem(deadline: startDate.date, title: titleField.text!, UUID: NSUUID().UUIDString)
        TodoMedicineList.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
    }

    
    
    var datePickerHidden = false
    var endPickerHidden = false
    
    
    func datePickerChanged () {
        startLabel.text = NSDateFormatter.localizedStringFromDate(startDate.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }
    
    func endDateChanged(){
        
                endDateDetail.text = NSDateFormatter.localizedStringFromDate(endDatePicker.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }
    
    @IBAction func startDatePickerValue(sender: UIDatePicker) {
        datePickerChanged()
    }
    @IBAction func endDatePickerValue(sender: AnyObject) {
        endDateChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerChanged()
        endDateChanged()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        repeatLbl.text = repeatSelectedValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       // print(":::::::: SEGUE :::::::::::::: ",segue.identifier)
    }
    
    
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
       // print("in medicine ",identifier," ::: ",sender)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
     
        if indexPath.section == 1 && indexPath.row == 0 {
            toggleDatepicker()
        }else if indexPath.section == 2 && indexPath.row == 0 {
            toggleEndPicker()
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     
        if datePickerHidden && indexPath.section == 1 && indexPath.row == 1 {
            return 0
        } else  if endPickerHidden && indexPath.section == 2 && indexPath.row == 1 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    //Start Date picker
    func toggleDatepicker() {
        
        datePickerHidden = !datePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    // End date picker
    func toggleEndPicker(){
        endPickerHidden = !endPickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    
    
    
    
    

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

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
