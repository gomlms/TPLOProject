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
    
    var procedure : Procedure?
    
    //MARK: Properties
    
    @IBOutlet weak var radiographImageView: UIImageView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var pointOneCreated = false
    var pointTwoCreated = false
    
    var radiographImage : UIImage?
    
    //var currentProcedure : Procedure
    
    //MARK: Actions
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let procedure = procedure else{
            fatalError("Procedure was not correctly passed to Relative Distance Controller")
        }
        radiographImage = procedure.radiograph
        
        radiographImageView.image = radiographImage
        
        if(procedure.name == "Max"){
            os_log("Procedure Successfully Passed")
        }
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
