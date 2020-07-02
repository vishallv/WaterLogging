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
    //Singleton design to create only one for the HealthDataStore for the app life cycle
    static let shared = HealthDataStore()
    //Instance of the HKHealthStore
    private let healthStore : HKHealthStore = HKHealthStore()
    
    // Set of HKSampleType to read and write access
    static var allTypes : [HKSampleType] {
        let identifiers = [HKQuantityTypeIdentifier.bodyMass.rawValue]
        
        // returns all the non nil health sample type using compact map
        return identifiers.compactMap { getHealthSampleType(identifier: $0)}
    }
    
    //MARK: Helper Function
    
    //method to check the current HealthKit authorization status for the application
    func getAuthorizationStatus(){
        
        //Check if current device has access to HealthKit
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
                //If any changes in the read and write sample type request authorization to read and write data
                self?.requestUserToReadAndWriteData()
            case .unnecessary:
                print("unnecessary")
                
            @unknown default:
                fatalError()
            }
        }
    }
    
    func requestUserToReadAndWriteData(){
        //Check if current device has access to HealthKit
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
    
    
    // Based on the user's input store the data to HealthStore and return a boolean success through a completion block
    func addUserBodyMassToHealthStore(withWeight weight : Double , completion : @escaping(Bool) -> Void){
        
        // Confirm if the HKQuantitySample is not nil
        guard let quantitySample = convertWeightToQuantitySample(weight) else {
            completion(false)
            return}
        
        //Store data to HealthStore
        healthStore.save(quantitySample) { (success, error) in
            if let error = error{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    //Convert Weight to HKQuantitySample with unit, quantity type body mass and return HKQuantitySample
    private func convertWeightToQuantitySample(_ weight : Double) -> HKQuantitySample?{
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {return nil}
        let unit : HKUnit = .pound()
        let today = Date()
        let start = today
        let end = today
        
        
        let quantity = HKQuantity(unit: unit, doubleValue: weight)
        
        return HKQuantitySample(type: quantityType, quantity: quantity, start: start, end: end)
        
        
    }
    
    //Access the latest body mass sample from last 7 days and return body mass in pound through a escaping closure
    func getUserMostRecentBodyMass(completion : @escaping(Double)->Void){
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {return}
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day, value: -7, to: Date()), end: nil, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            
            if let sample = samples?.first as? HKQuantitySample{
                //Return the body mass if value exists or send a average weight of American's which is 136 pounds
                completion(sample.quantity.doubleValue(for: .pound()))
            }
            else{
                completion(136)
            }
        }
        
        //Execute the query on the healthstore
        healthStore.execute(query)
    }
    
    
    
}

func getHealthSampleType(identifier : String) -> HKSampleType?{
    
    if let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: identifier)){
        return quantityType
    }
    return nil
}

