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
    
    static var allTypes : [HKSampleType] {
        let identifiers = [HKQuantityTypeIdentifier.bodyMass.rawValue]
        
        return identifiers.compactMap { getHealthSampleType(identifier: $0)}
    }
    
    //MARK: Helper Function
    
    func getAuthorizationStatus(){
        
        if !HKHealthStore.isHealthDataAvailable(){
            print("Device Is not compatible with HealthKit")
            return
        }
        
        
        healthStore.getRequestStatusForAuthorization(toShare: Set(HealthDataStore.allTypes), read: Set(HealthDataStore.allTypes)) {[weak self] (status, error) in
            if !HKHealthStore.isHealthDataAvailable(){
                print("Device Is not compatible with HealthKit")
                return
            }
            
            switch status{
            
            case .unknown:
                print("unknown")
            case .shouldRequest:
                self?.requestUserToReadAndWriteData()
            case .unnecessary:
                print("unnecessary")
                
            @unknown default:
                fatalError()
            }
        }
    }
    
    func requestUserToReadAndWriteData(){
        
        if !HKHealthStore.isHealthDataAvailable(){
            print("Device Is not compatible with HealthKit")
            return
        }
        
        healthStore.requestAuthorization(toShare: Set(HealthDataStore.allTypes), read: Set(HealthDataStore.allTypes)) {(success, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            if success {
                print("Successfully requested authorization")
            }
            
            
        }
        
    }
    
    
    
}

func getHealthSampleType(identifier : String) -> HKSampleType?{
    
    if let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: identifier)){
        return quantityType
    }
    return nil
}

