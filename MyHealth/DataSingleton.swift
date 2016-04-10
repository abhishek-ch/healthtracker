//
//  DataSingleton.swift
//  MyHealth
//
//  Created by Abhishek Choudhary on 30/03/2016.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import Foundation

class DataSingleton {
    static let sharedInstance = DataSingleton()
    private init() {}
    
    var heartRate : Double = 58.0
    
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var defaultsGrp: NSUserDefaults = NSUserDefaults(suiteName: "group.com.myheart.health.MyHealth")!
    var phoneName : String = "Avril"
    var phoneNumber : String = "8097123412"
    
    func getPhoneName() -> String {
        var value = defaultsGrp.valueForKey("name")
        if value == nil{
            value = defaults.valueForKey("nameTF")
            if value == nil{
                value = phoneName
            }
            
        }
        return value as! String
        
    }
    
    
    func getPhoneNumber() -> String {
        var value = defaultsGrp.valueForKey("mainphone")
        if value == nil{
            value = defaults.valueForKey("phoneTF")
            if value == nil{
                value = phoneNumber
            }
            
        }
        return value as! String
        
    }

}
