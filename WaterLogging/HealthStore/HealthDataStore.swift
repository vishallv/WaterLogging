//
//  HealthDataStore.swift
//  WaterLogging
//
//  Created by Vishal Lakshminarayanappa on 7/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import HealthKit

class HealthDataStore {
    
    //MARK: Properties
    private init() {}
    static let shared = HealthDataStore()
    private let healthStore : HKHealthStore = HKHealthStore()
    
    //MARK: Helper Function
    
    

}
