//
//  ViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 1/16/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit
import os.log

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    var procedures = [Procedure]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: TableView
    
    //Number of rows in table view
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return procedures.count
    }
    
    //Create a cell for each table view row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        let cellIdentifier = "ProcedureCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProcedureCell else {
            fatalError("The dequeued cell is not an instance of ProcedureCell")
        }
        
        let procedure = procedures[indexPath.row]
        
        cell.date.text = procedure.dateOfProcedure
        cell.name.text = procedure.name
        cell.radiograph.image = procedure.radiograph
        
        return cell
    }
    
    //Method to run when table view cell is tapped
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath) {
        
    }
    
    //MARK: Private Methods
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(procedures, toFile: (Procedure.ArchiveURL?.path)!)
        
        if(isSuccessfulSave){
            os_log("Procedures saved successfully", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save procedures", log:OSLog.default, type: .error)
        }
    }
    
    private func loadProcedures() -> [Procedure]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: (Procedure.ArchiveURL?.path)!) as? [Procedure]
    }

}

