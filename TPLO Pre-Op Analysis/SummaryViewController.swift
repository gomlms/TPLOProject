//
//  SummaryViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 2/28/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit
import MessageUI

class SummaryViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var sendEmailButton: UIButton!

    var procedure : Procedure?
    var isThere = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let procedure = procedure else {
            fatalError("Procedure was not correctly passed to Summary Controller")
        }
        
        procedure.tpa = getAngle()
        
        outputLabel.text = "Date: \(procedure.dateOfProcedure)\nPatient Name: \((procedure.name)!)\nTPA: \(procedure.tpa)°\nOsteotomy Rotation: \((procedure.chordLength)!)mm\nSawblade Size: \((procedure.roundedRadius)!)mm\nPlate Size: \((procedure.plateCatalogNumber)!)";

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmailPressed(_ sender: Any) {
        if(MFMailComposeViewController.canSendMail()){
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setSubject("TPLO Pre-Op Analysis Summary Report")
            mailComposer.setMessageBody("Date: \(procedure?.dateOfProcedure)\nPatient Name: \((procedure?.name)!)\nTPA: \(procedure?.tpa)°\nOsteotomy Rotation: \((procedure?.chordLength)!)mm\nSawblade Size: \((procedure?.roundedRadius)!)mm\nPlate Size: \((procedure?.plateCatalogNumber)!)", isHTML: false)
            
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "StartScreen":
            guard let startViewController = segue.destination as? MainScreenViewController else {
                fatalError("Unexpected Destination: \(segue.destination)")
            }
            if(!isThere){
                startViewController.procedures.append(procedure!)
            }
        default:
            fatalError("Unexpected segue identifier: \(segue.identifier)")
        }
    }
    
    func getAngle () -> Double {
        let angle2I = Double(atan2((procedure?.points[1].y)! - (procedure?.intersectionPoint.y)!, (procedure?.points[1].x)! - (procedure?.intersectionPoint.x)!))
        let angle4I = Double(atan2((procedure?.points[3].y)! - (procedure?.intersectionPoint.y)!, (procedure?.points[3].x)! - (procedure?.intersectionPoint.x)!))
        var angle = Double(angle2I - angle4I)
        angle = angle * (180.0 / M_PI)
        return angle
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
