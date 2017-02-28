//
//  SummaryViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 2/28/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var outputLabel: UILabel!

    var procedure : Procedure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let procedure = procedure else {
            fatalError("Procedure was not correctly passed to Summary Controller")
        }
        
        outputLabel.text = "Date: \(procedure.dateOfProcedure)\nPatient Name: \(procedure.name)\nTPA: \(procedure.tpa)°\nOsteotomy Rotation: \(procedure.chordLength)mm\nSawblade Size: \(procedure.sawbladeSize)mm\nPlate Size: \(procedure.plateCatalogNumber)";

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
