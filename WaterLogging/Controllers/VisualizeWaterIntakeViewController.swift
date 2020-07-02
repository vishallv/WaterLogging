//
//  VisualizeWaterIntakeViewController.swift
//  WaterLogging
//
//

import UIKit

class VisualizeWaterIntakeViewController: UIViewController {


    //MARK: Properties
    private let trackingLabel = UILabel()
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

    private func setUp() {
        trackingLabel.text = "X oz of X oz goal consumed today"
        trackingLabel.textColor = .label
        view.backgroundColor = .systemBackground
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        trackingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackingLabel)
        
        // Label constraints
        
        let trackingLabelConstraints = [trackingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                    trackingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                    trackingLabel.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
                                    trackingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
                                    trackingLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor),
                                    trackingLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(trackingLabelConstraints)
        
    }
}

extension VisualizeWaterIntakeViewController {
    private func configureConsumptionAndGoalLabel(){
       
        let goalValue = UserDefaults.standard.double(forKey: goalFromUserDefaults)
        trackingLabel.text = "X oz of \(Int(goalValue)) oz goal consumed today"
        
    }
}
