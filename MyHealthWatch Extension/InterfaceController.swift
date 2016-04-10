//
//  InterfaceController.swift
//  MyHealthWatch Extension
//
//  Created by Abhishek Choudhary on 06/11/2015.
//  Copyright © 2015 ABC. All rights reserved.
//


import WatchKit
import Foundation
import HealthKit
import UIKit



/** Watch Notification & Controller **/
class InterfaceController: WKInterfaceController,HKWorkoutSessionDelegate {
    
    
    @IBOutlet var heart: WKInterfaceImage!
    @IBOutlet var headerLbl: WKInterfaceLabel!
    
    @IBOutlet var outputLbl: WKInterfaceLabel!
    
    
    let healthStore: HKHealthStore = HKHealthStore()
    
    // define the activity type and location
    var workoutSession = HKWorkoutSession(activityType: HKWorkoutActivityType.CrossTraining, locationType: HKWorkoutSessionLocationType.Indoor)
    let heartRateUnit = HKUnit(fromString: "count/min")
    var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    
    var workoutEndDate: NSDate!
    var workoutStartDate: NSDate!
    var heartRateSample: [HKQuantitySample] = []
    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        workoutSession.delegate = self
        print("Waakeeeee ")
        // Configure interface objects here.
    }
    
    //ass workout session is killed it cannot be restarted
    //so everytime after session is killed we are creating a n
    //new workout session
    func reCreateWorkoutSession(){
        workoutSession = HKWorkoutSession(activityType: HKWorkoutActivityType.CrossTraining, locationType: HKWorkoutSessionLocationType.Indoor)
        workoutSession.delegate = self
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
//        defaults.setDouble(58.0, forKey: "heartRate")
        
        // If HealthStore is not accesible or user denies the access
        guard HKHealthStore.isHealthDataAvailable() == true else {
            headerLbl.setText("not available")
            return
        }
        
        //Accepts the HealthData quantity
        guard let quantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate) else {
            displayNotAllowed()
            return
        }
        
        //type of data to share from healthapp
        let typeToShare = Set(arrayLiteral: quantityType)
        let dataTypes = Set(arrayLiteral: quantityType)
        //requesting to autorize the HealthStore access
        healthStore.requestAuthorizationToShareTypes(typeToShare, readTypes: dataTypes) { (success, error) -> Void in
            if success == false {
                self.displayNotAllowed()
            }else{
                //triggers as soon as the UI Opens
                self.healthStore.startWorkoutSession(self.workoutSession)
            }
        }
        
        print("will activate ")
    }

    func displayNotAllowed() {
        headerLbl.setText("not allowed")
    }
    
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        healthStore.endWorkoutSession(workoutSession)
        print("deactivate ")
        reCreateWorkoutSession()
    }
    
    /** Type of workout session
     If user running or stopped
     **/
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        switch toState {
        case .Running:
            workoutDidStart(date)
        case .Ended:
            workoutDidEnd(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        // Do nothing for now
        print("faiLC asee ",error )
    }
    
    

    
    //https://github.com/schickling/hackrisk-calm/blob/master/Calm/HealthKitHelper.swift
    //triggers the workout state
    func workoutDidStart(date : NSDate) {
        print("WORK OUT DID START")
        self.workoutStartDate = date
        NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: Selector(nilLiteral: triggerQuery()), userInfo: nil, repeats: true)

    }
    

    
    
    
    let countPerMinuteUnit = HKUnit(fromString: "count/min")

    
    func saveWorkout() -> Void {
        print("Came to Save")
        //save a workout if there are valid start and end dates
        // guard let startDate = self.workoutStartDate, endDate = self.workoutEndDate else {return}
        
        if self.heartRateSample.count >= 1{
            let heartRateSample: HKQuantitySample = self.heartRateSample[self.heartRateSample.count - 1]
            
            let completion: ((Bool, NSError?) -> Void) = {
                (success, error) -> Void in
                
                if !success {
                    print("An error occured saving the Heart Rate sample \(heartRateSample). In your app, try to handle this gracefully. The error was: \(error).")
                    
                    abort()
                }else{
                    print("Save Done ",heartRateSample)
            
                    
                }
                
            }
            
            //self.healthStore.saveObject(<#T##object: HKObject##HKObject#>, withCompletion: <#T##(Bool, NSError?) -> Void#>)
            
            self.healthStore.saveObject(heartRateSample, withCompletion: completion)
        }
        

        
    }
    
    override func willDisappear() {
        print("Content Has Disappaerrad")
    }
    
    
    
    let defaultsGrp = NSUserDefaults(suiteName: "group.com.myheart.health.MyHealth")
    // save the workout
    @IBAction func saveBtnPressed() {
        
        if self.minHeartRate < 55.0 {
            print("Heart Rate crossed Minimum")
            defaultsGrp?.setDouble(self.minHeartRate, forKey: "heartRateMain")
            
        }else if self.maxHeartRate > 60.0 {
            print("Heart rate Crossed Maximum")
            defaultsGrp?.setDouble(self.maxHeartRate, forKey: "heartRateMain")
        }
        defaultsGrp?.synchronize()
        saveWorkout()

    }
    
    //triggers the workout session
    @IBAction func startBtnPressed() {
        healthStore.startWorkoutSession(workoutSession)
        
    }
    
    @IBAction func stopBtnPressed() {
        healthStore.endWorkoutSession(workoutSession)
    }
    
    //on killing the heart rate , stop the executing query 
    //and change the text and save the heart rate
    func workoutDidEnd(date : NSDate) {
        self.workoutEndDate = date
        
        if let query = createHeartRateStreamingQuery(date) {
            headerLbl.setText("Killing Healthkit...")
            healthStore.stopQuery(query)
            headerLbl.setText("Stop")
            saveWorkout()
        } else {
            headerLbl.setText("cannot stop")
        }
        
    }
    
    
    
    func triggerQuery() {
        let currentDate = NSDate()
        if let query = createHeartRateStreamingQuery(currentDate) {
            healthStore.executeQuery(query)
        }
    }
    
    //creates Heart rate query
    func createHeartRateStreamingQuery(workoutStartDate: NSDate) -> HKQuery? {
        // adding predicate will not work
        let predicate = HKQuery.predicateForSamplesWithStartDate(workoutStartDate, endDate: nil, options: HKQueryOptions.None)
        
        
        guard let quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate) else { return nil }
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: anchor, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            guard let newAnchor = newAnchor else {return}
            self.anchor = newAnchor
            self.updateHeartRate(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            self.anchor = newAnchor!
            self.updateHeartRate(samples)
        }
        
        return heartRateQuery
    }
    
    
    
    
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var maxHeartRate:Double = 60.0
    var minHeartRate:Double = 24.0

    
    //updates heart rate, here can be schedule if heart rate crosses certain level
    func updateHeartRate(samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
      
       
//        defaultsGrp.setDouble(99.0, forKey: "heartRateMain")
//        defaultsGrp.synchronize()
//        print("SETING THE VAKUE LAUNDEeeeeeeee ",defaultsGrp.doubleForKey("heartRateMain"))
        //let max_heart_rate = defaults.valueForKey("hearyRate") as? Int
        
        DataSingleton.sharedInstance.heartRate = 96.0
        
        dispatch_sync(dispatch_get_main_queue()) {
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValueForUnit(self.heartRateUnit)
            let default_heartRate = self.defaults.doubleForKey("heartRate")
            
            
            self.maxHeartRate = max(self.maxHeartRate,value)
            self.minHeartRate = max(self.minHeartRate,value)
           

//            print("WHAT IS THE VALUE :) ",DataSingleton.sharedInstance.heartRate)
            //defaultsGrp!.setDouble(value, forKey: "heartRateMain")
//            if let defaultsgp = NSUserDefaults(suiteName: appGroupID) {
//                defaultsgp.setValue(value, forKey: "heartRateMain")
//            }

            if let phoneTF = self.defaults.stringForKey("phoneTF")
            {
                print("phonssseTF",phoneTF)
            }
           // print("Valueeee==> ", value)
            if(default_heartRate < value && (value > 60.0 || value < 55.0)){
                
//               print("DFINALALLALALALALLAAL :) ",DataSingleton.sharedInstance.heartRate)
          
                self.defaults.setDouble(value, forKey: "heartRate")
                //self.defaults.setInteger(UInt16(value), forKey: "heartRate")
                //self.defaults.setObject(value, forKey: "heartRate")
                self.defaults.synchronize()
//                print("The value now is=s> ",self.defaults.doubleForKey("heartRate"))
                
                
            }
            

            
            
            //  print("valu ",value," Time ",NSDate() )
            self.outputLbl.setText(String(UInt16(value)))
            self.heartRateSample += heartRateSamples
            // retrieve source from sample
            let name = sample.sourceRevision.source.name
            self.updateDeviceName(name)
            self.animateHeart()
        }
        
        
        
        
    }
    
    
    
    func updateDeviceName(deviceName: String) {
        headerLbl.setText(deviceName)
    }
    
    //heart rate animation which shows heart beat
    func animateHeart() {
        self.animateWithDuration(0.5) {
            self.heart.setWidth(60)
            self.heart.setHeight(90)
        }
        
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * double_t(NSEC_PER_SEC)))
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_after(when, queue) {
            dispatch_async(dispatch_get_main_queue(), {
                self.animateWithDuration(0.5, animations: {
                    self.heart.setWidth(50)
                    self.heart.setHeight(80)
                })
            })
        }
    }
    


    override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
        _ = userInfo!["identifier"] as! String
        
        print(" HANDLDLLD handleUserActivity " ,userInfo?["identifier"])
    }
    
    override func handleActionWithIdentifier(identifier: String?, forLocalNotification localNotification: UILocalNotification) {
        print("CLCK HANDLE NOTIFICATIOn .......... ",identifier)
    }
}
