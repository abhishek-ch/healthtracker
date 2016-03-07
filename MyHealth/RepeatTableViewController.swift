//
//  RepeatTableViewController.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 12/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//

import UIKit

class RepeatTableViewController: UITableViewController {
    
    var  intervals = [String]()
    var selectedRepeat = Int()
    
    //http://stackoverflow.com/questions/6966365/uilocalnotification-repeat-interval-for-custom-alarm-sun-mon-tue-wed-thu-f
    enum RepeatInterval : String, CustomStringConvertible {
        case Never = "Never"
        case Every_Day = "Every Day"
        case Every_Week = "Every Week"
        case Every_2_Weeks = "Every 2 Weeks"
        case Every_Month = "Every Month"
        case Every_Year = "Every Year"
        
        var description : String { return rawValue }
        
        static let allValues = [Never, Every_Day, Every_Week, Every_2_Weeks, Every_Month, Every_Year]
    }
    
    
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        
        //MedicineInputTableViewController
        print("PERFORMRMRMRRM ",sender," idee ",identifier)
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print(" prepare for Repeat ",segue.destinationViewController)
        let destination = segue.destinationViewController as? MyHealth.MedicineInputTableViewController
        //print(destination!.repeatSelectedValue)
        //print("selectedRepeat ",selectedRepeat)
        destination!.repeatSelectedValue = intervals[selectedRepeat] 

        
        /** Close the view after operation, need to work on this **/
       // self.dismissViewControllerAnimated(true, completion: nil )
        //navigationController?.popViewControllerAnimated(true)
        //var StatusVC: MedicineInputTableViewController = MedicineInputTableViewController()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intervals = ["Never","Every Day","Every Week","Every 2 Weeks","Every Month","Every Year"]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return intervals.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Choices"
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repeatIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel!.text = intervals[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       // print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label text here and storing it to the variable
        //let indexPathVal: NSIndexPath = tableView.indexPathForSelectedRow!
        //print("\(indexPathVal)")
        //let currentCell = tableView.cellForRowAtIndexPath(indexPathVal) as UITableViewCell!;
        //print("\(currentCell)")
        //print("\(currentCell.textLabel?.text!)")
        
        selectedRepeat = indexPath.row
        //Storing the data to a string from the selected cell
   
        //Now here I am performing the segue action after cell selection to the other view controller by using the segue Identifier Name
        self.performSegueWithIdentifier("medDetailsSegue", sender: self)
    }


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
