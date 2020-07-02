//
//  DefaultStore.swift
//  WaterLogging
//
//  Created by Vishal Lakshminarayanappa on 7/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

// Global variable which are keys to access UserDefaults 
let goalFromUserDefaults = "goalFromUserDefaults"
let userWaterConsumptionForToday = "userWaterConsumptionForToday"
let setTodayDateInDefaults = "setTodayDateInDefaults"

class DefaultStore {
    
    //MARK: Properties
    //Singleton design to create only one for the HealthDataStore for the app life cycle
    static let shared = DefaultStore()
    private init() {}
    
    //MARK: Helper Function
    
    //Store today's date in the UserDefaults
    func setupTodayDateToDefaults(){
        let storeData = getTodaysDateString()
        UserDefaults.standard.set(storeData, forKey: setTodayDateInDefaults)
    }
    
    // Compare today's date with the value in UserDefaults if they don't match update the date to today and userWaterConsumptionForToday to zero
    func checkIfUserDefaultDateIsSameAsToday(){
        
        if let dateString = UserDefaults.standard.object(forKey: setTodayDateInDefaults) as? String{
            if dateString != getTodaysDateString(){
                setupTodayDateToDefaults()
                UserDefaults.standard.set(0, forKey: userWaterConsumptionForToday)
            }
        }
        else{
            setupTodayDateToDefaults()
        }
    }
    //Store goal From User in the UserDefaults
    func setupGoalDataToUserDefaults(withGoal goal : Double){
        UserDefaults.standard.set(goal, forKey: goalFromUserDefaults)
    }
    
    //Increase the water consumption by 8 OZ in UserDefaults
    func addUserConsumptionByEightOZ(){
        var totalConsumption = UserDefaults.standard.double(forKey: userWaterConsumptionForToday)
        totalConsumption += 8
        UserDefaults.standard.set(totalConsumption, forKey: userWaterConsumptionForToday)
    }
    
    //Returns a string based on the goalValue and todayIntake
    func getDataToSetLabelForVisualController() -> String{
        
        let goalValue = UserDefaults.standard.double(forKey: goalFromUserDefaults)
        let todayIntake = UserDefaults.standard.double(forKey: userWaterConsumptionForToday)
        return "\(Int(todayIntake)) oz of \(Int(goalValue)) oz goal consumed today"
    }
    
    func getTodaysConsumption() ->Int{
        return Int(UserDefaults.standard.double(forKey: userWaterConsumptionForToday))
    }
    
}

extension DefaultStore{
    func getTodaysDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        return formatter.string(from: Date())
        
    }
}
