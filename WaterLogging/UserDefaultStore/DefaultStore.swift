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
    
    func setupGoalDataToUserDefaults(withGoal goal : Double){
        UserDefaults.standard.set(goal, forKey: goalFromUserDefaults)
    }
    
    
}
