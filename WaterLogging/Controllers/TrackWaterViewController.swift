//
//  TrackWaterViewController.swift
//  WaterLogging
//
//

import UIKit

class TrackWaterViewController: UIViewController {
    
    
    //MARK: Properties
    private let addWaterButton = UIButton()
    private let updateGoalButton = UIButton()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       checkIfUserDefaultDateIsSameAsToday()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    // Actions
    
    @objc private func addWaterButtonPressed() {
        DefaultStore.shared.addUserConsumptionByEightOZ()
        presentCustomAlert(title: "Yippie", message: "Great progress", subTitle: "Ok", style: .default)
    }
    
    @objc private func goalButtonPressed() {
        setupAlertControllerToAddGoal()
    }
    
    //MARK: Helper Function
    
    private func checkIfUserDefaultDateIsSameAsToday(){
        DefaultStore.shared.checkIfUserDefaultDateIsSameAsToday()
    }
    
    // Set Up
    
    private func setUp() {
        addWaterButton.setTitle("Add 8 oz Water", for: .normal)
        updateGoalButton.setTitle("Update Daily Goal", for: .normal)
        addWaterButton.addTarget(self, action: #selector(addWaterButtonPressed), for: .touchUpInside)
        updateGoalButton.addTarget(self, action: #selector(goalButtonPressed), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
        addWaterButton.backgroundColor = .black
        updateGoalButton.backgroundColor = .black
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        let container = UIView()
        addWaterButton.translatesAutoresizingMaskIntoConstraints = false
        updateGoalButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(addWaterButton)
        container.addSubview(updateGoalButton)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(container)
        
        // Buttons constraints
        let addWaterButtonConstraints = [addWaterButton.topAnchor.constraint(equalTo: container.topAnchor),
                                         addWaterButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                         addWaterButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),]
        
        NSLayoutConstraint.activate(addWaterButtonConstraints)
        
        let updateGoalButtonConstraints = [updateGoalButton.topAnchor.constraint(equalTo: addWaterButton.bottomAnchor, constant: 10),
                                           updateGoalButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                           updateGoalButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                                           updateGoalButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)]
        
        NSLayoutConstraint.activate(updateGoalButtonConstraints)
        
        // ContainerView constraints
        
        let containerConstraints = [container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                    container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                    container.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
                                    container.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
                                    container.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor),
                                    container.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(containerConstraints)
        
    }

    
    
    
    

}

extension TrackWaterViewController {
    
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
}
