//
//  Procedure.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 1/20/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit
import os.log

class Procedure: NSObject, NSCoding {

    //MARK: Properties
    var name : String
    var dateOfProcedure : String
    var radiograph : UIImage?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let ArchiveURL = DocumentsDirectory?.appendingPathComponent("procedures")
    
    //MARK: Initialization
    init?(n:String, r:UIImage?, d:String){
        guard !n.isEmpty else {
            return nil
        }
        
        name = n
        radiograph = r
        dateOfProcedure = d
    }
    
    
    //MARK: NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(dateOfProcedure, forKey: PropertyKey.dateOfProcedure)
        aCoder.encode(radiograph, forKey: PropertyKey.radiograph)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else{
            os_log("Unable to decode name of radiograph", log: OSLog.default, type:.debug)
            return nil
        }
        
        let dateOfProcedure = aDecoder.decodeObject(forKey: PropertyKey.dateOfProcedure) as! String
        let radiograph = aDecoder.decodeObject(forKey: PropertyKey.radiograph) as? UIImage
    
        self.init(n: name, r: radiograph, d: dateOfProcedure)
    }
    
    //MARK: Types
    struct PropertyKey{
        static let name = "name"
        static let dateOfProcedure = "dateOfProcedure"
        static let radiograph = "radiograph"
    }
}
