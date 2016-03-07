//
//  TodoMedicine.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 07/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//

import Foundation

/** Object to handle variable for Medicine data 
 it acts like a bean object
 **/
struct TodoMedicineItem {
    var title: String
    var deadline: NSDate
    var UUID: String
    
    init(deadline: NSDate, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending) // deadline is earlier than current date
    }
}