//
//  SawbladeViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 2/6/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class SawbladeViewController: UIViewController {

    //MARK: Properties
    var procedure : Procedure?
    var sawbladeRadiusMM : Double?
    var roundedRadius : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        procedure?.sawbladeRadius = sqrt(Double(pow(((procedure?.points[4].x)! - (procedure?.points[0].x)!), 2) * pow(((procedure?.points[4].y)! - (procedure?.points[0].y)!), 2)))
        
        sawbladeRadiusMM = (procedure?.sawbladeRadius)! * (procedure?.pixelToMMRatio)!
        
        if(sawbladeRadiusMM! >= 15.0 && sawbladeRadiusMM! < 16.5){
            roundedRadius = 15
        } else if(sawbladeRadiusMM! > 16.5 && sawbladeRadiusMM! <= 19.5) {
            roundedRadius = 18
        } else if(sawbladeRadiusMM! > 19.5 && sawbladeRadiusMM! <= 22.5) {
            roundedRadius = 21
        } else if(sawbladeRadiusMM! > 22.5 && sawbladeRadiusMM! <= 25.5) {
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if(segue.identifier == "Continue"){
            guard let nextController = segue.destination as? OsteotomyViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            nextController.procedure = procedure
        }
    }

}
