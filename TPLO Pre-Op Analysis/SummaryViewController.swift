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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let procedure = procedure else {
            fatalError("Procedure was not correctly passed to Summary Controller")
        }
        
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
            startViewController.procedures.append(procedure!)
        default:
            fatalError("Unexpected segue identifier: \(segue.identifier)")
        }
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
