//
//  HomeViewController.swift
//  Locate
//
//  Created by Shubham Singh on 22/11/20.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK:- outlets for the viewController
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK:- variables for the viewController
    override class func description() -> String {
        return "ViewController"
    }
    
    // MARK:- lifeCycle for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.currentCity.bind {
            if let currentCity = $0 {
                self.locationLabel.text = currentCity
            } else {
                self.locationLabel.text = "Unknown"
            }
        }
    }
}

