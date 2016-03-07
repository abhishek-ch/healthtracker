//
//  MedicineTableViewController.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 09/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//

import UIKit

class MedicineTableViewController: UITableViewController {

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        return cell
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
}
