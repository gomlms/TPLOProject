//
//  RelativeDistanceViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 1/22/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit
import os.log

class RelativeDistanceViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var radiographImageView: UIImageView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var pointOneCreated = false
    var pointTwoCreated = false
    
    var radiographImage : UIImage = #imageLiteral(resourceName: "defaultPhoto")
    
    //var currentProcedure : Procedure
    
    
    //MARK: Actions
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private Methods
    private func updateNextButtonState() {
        if pointOneCreated && pointTwoCreated {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }

}
