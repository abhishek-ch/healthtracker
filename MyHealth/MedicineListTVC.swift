//
//  MedicineListTVC.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 07/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//

import UIKit

class MedicineListTVC: UIViewController {

    
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    @IBAction func savePressed(sender: UIButton) {
        print("Saving d values")
        let todoItem = TodoMedicineItem(deadline: deadlinePicker.date, title: titleField.text!, UUID: NSUUID().UUIDString)
        TodoMedicineList.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
        

    }
}
