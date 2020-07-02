//
//  DefaultStore.swift
//  WaterLogging
//
//  Created by Vishal Lakshminarayanappa on 7/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
let goalFromUserDefaults = "goalFromUserDefaults"
let userWaterConsumptionForToday = "userWaterConsumptionForToday"
let setTodayDateInDefaults = "setTodayDateInDefaults"

class DefaultStore {
    
    //MARK: Properties
    
    static let shared = DefaultStore()
    private init() {}
    
    //MARK: Helper Function
    
    func setupTodayDateToDefaults(){
        let storeData = getTodaysDateString()
        UserDefaults.standard.set(storeData, forKey: setTodayDateInDefaults)
    }
    
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
    
    func setupGoalDataToUserDefaults(withGoal goal : Double){
        UserDefaults.standard.set(goal, forKey: goalFromUserDefaults)
    }
    
    func addUserConsumptionByEightOZ(){
        var totalConsumption = UserDefaults.standard.double(forKey: userWaterConsumptionForToday)
        totalConsumption += 8
        UserDefaults.standard.set(totalConsumption, forKey: userWaterConsumptionForToday)
    }
    
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
