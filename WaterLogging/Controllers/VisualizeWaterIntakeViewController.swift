//
//  VisualizeWaterIntakeViewController.swift
//  WaterLogging
//
//

import UIKit

class VisualizeWaterIntakeViewController: UIViewController {


    //MARK: Properties
    private let trackingLabel = UILabel()
    private let manualTrackingLabel :  UILabel = {
        let label = UILabel()
        label.text = "X oz of X oz goal consumed today \nbased of your weight"
        label.numberOfLines = 2
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    //MARK: Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureConsumptionAndGoalLabel()
        configureManualTrackingLabelBasedOnUserWeight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
        configureConsumptionAndGoalLabel()
    }
    
    //MARK: Selector
    
    //MARK: Helper Function
    // Set Up
    
    //Get the updated user mass from health store and update the manualTrackingLabel text on the main thread
    private func configureManualTrackingLabelBasedOnUserWeight(){
        HealthDataStore.shared.getUserMostRecentBodyMass { [weak self](mass) in
            DispatchQueue.main.async {
                let waterConsumptionValue = DefaultStore.shared.getTodaysConsumption()
                self?.manualTrackingLabel.text = "\(waterConsumptionValue) oz of \(Int(mass * 2/3)) oz goal consumed today \nbased of your weight"
            }
        }
    }

    private func setUp() {
        trackingLabel.text = "X oz of X oz goal consumed today"
        trackingLabel.textColor = .label
        view.backgroundColor = .systemBackground
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        trackingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackingLabel)
        manualTrackingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(manualTrackingLabel)
        
        // Label constraints
        
        let trackingLabelConstraints = [trackingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                    trackingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                    trackingLabel.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
                                    trackingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
                                    trackingLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor),
                                    trackingLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(trackingLabelConstraints)
        
        NSLayoutConstraint.activate([
            manualTrackingLabel.topAnchor.constraint(equalTo: trackingLabel.bottomAnchor, constant: 30),
            manualTrackingLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            manualTrackingLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
    }
}

extension VisualizeWaterIntakeViewController {
    private func configureConsumptionAndGoalLabel(){
        let trackingLabelText = DefaultStore.shared.getDataToSetLabelForVisualController()
        trackingLabel.text = trackingLabelText
        
    }
}
