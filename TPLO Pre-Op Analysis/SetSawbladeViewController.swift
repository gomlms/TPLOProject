//
//  SetSawbladeViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 6/7/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class SetSawbladeViewController: UIViewController {

    var procedure : Procedure?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        guard let nextController = segue.destination as? TPAViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        nextController.procedure = procedure
    }
 

}
