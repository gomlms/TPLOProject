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
        
        if let savedProcedures = loadProcedures() {
            procedures += savedProcedures
        }
        
        saveProcedures()
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            procedures.remove(at: indexPath.row)
            saveProcedures()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if(editingStyle == .insert) {
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "AddItem":
            os_log("Adding a new procedure", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let procedureDetailViewController = segue.destination as? SummaryViewController else {
                fatalError("Unexpected Destination: \(segue.destination)")
            }
            guard let selectedProcedureCell = sender as? ProcedureCell else {
                fatalError("Unexpected Sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedProcedureCell) else{
                fatalError("The selected meal cell is not being displayed by the table")
            }
            let selectedProcedure = procedures[indexPath.row]
            procedureDetailViewController.procedure = selectedProcedure
        default:
            fatalError("Unexpected segue identifier: \(segue.identifier)")
        }
    }

    
    //Method to run when table view cell is tapped
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath) {
        
    }
    
    //MARK: Private Methods
    private func saveProcedures() {
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

