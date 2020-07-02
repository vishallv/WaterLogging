//
//  TrackWaterViewController+Extensions.swift
//  WaterLogging
//
//  Created by Vishal Lakshminarayanappa on 7/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

extension TrackWaterViewController{
    func setupAlertControllerToAddGoal(){
        let alertController = UIAlertController(title: "Water Consumption Goal!!", message: "Please enter you water consumption goal in Ounces", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter your goal"
        }
        
        let addConsumptionAction = UIAlertAction(title: "Update Goal", style: .default) { [weak self ,weak alertController](_) in
            
            guard let alertController = alertController, let textfield = alertController.textFields?.first else {return}
            
            if let alertText = textfield.text,let goalValue = Double(alertText){
                DefaultStore.shared.setupGoalDataToUserDefaults(withGoal: goalValue)
                
            }
            else{
                self?.presentCustomAlert(title: "Error", message: "Invalid Data Entry! Please enter valid number", subTitle: "Try Again", style: .default, shouldPresent: true)
            }
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addConsumptionAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentCustomAlert(title : String, message : String,subTitle : String, style : UIAlertAction.Style,shouldPresent : Bool = false){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let customAction = UIAlertAction(title: subTitle, style: style) { [weak self] _ in
            if shouldPresent{
                self?.setupAlertControllerToAddGoal()
            }
        }
        alertController.addAction(customAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertToInputUserWeight(){
        let alertController = UIAlertController(title: "Health Data", message: "Please enter you weight in pounds!", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter your Weight"
        }
        
        let addConsumptionAction = UIAlertAction(title: "OK", style: .default) { [weak self ,weak alertController](_) in
            
            guard let alertController = alertController, let textfield = alertController.textFields?.first else {return}
            
            if let alertText = textfield.text,let weightValue = Double(alertText){
                HealthDataStore.shared.addUserBodyMassToHealthStore(withWeight: weightValue) { (success) in
                    if !success{
                        DispatchQueue.main.async {
                            self?.presentCustomAlert(title: "Error", message: "Please provide permission for write", subTitle: "Ok", style: .default)
                            
                        }
                    }
                }
                
            }
            else{
                self?.presentCustomAlert(title: "Error", message: "Invalid Data type! Enter a valid weight", subTitle: "Try Again", style: .destructive)
            }
            
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addConsumptionAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
