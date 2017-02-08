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
    var name : String?
    var dateOfProcedure : String
    var radiograph : UIImage?
    var points = [CGPoint]()
    var intersectionPoint = CGPoint.zero
    var tpa : Double = 0.0
    var sawbladeRadius : Double?
    var sawbladeSize : Int?
    var sawCatalogNumber : String?
    var radius : Double?
    var chordLength : Double?
    var plateCatalogNumber : String?
    var pixelToMMRatio : Double?
    var designator : String?
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let ArchiveURL = DocumentsDirectory?.appendingPathComponent("procedures")
    
    //MARK: Initialization
    init?(n:String, r:UIImage?, d:String, m:String){
        guard !n.isEmpty else {
            return nil
        }
        
        name = n
        radiograph = r
        dateOfProcedure = d
        designator = m
    }
    
    
    //MARK: NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(dateOfProcedure, forKey: PropertyKey.dateOfProcedure)
        aCoder.encode(radiograph, forKey: PropertyKey.radiograph)
        aCoder.encode(designator, forKey: PropertyKey.designator)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else{
            os_log("Unable to decode name of radiograph", log: OSLog.default, type:.debug)
            return nil
        }
        
        let dateOfProcedure = aDecoder.decodeObject(forKey: PropertyKey.dateOfProcedure) as! String
        let radiograph = aDecoder.decodeObject(forKey: PropertyKey.radiograph) as? UIImage
        let designator = aDecoder.decodeObject(forKey: PropertyKey.designator) as! String
    
        self.init(n: name, r: radiograph, d: dateOfProcedure, m: designator)
    }
    
    //MARK: Types
    struct PropertyKey{
        static let name = "name"
        static let dateOfProcedure = "dateOfProcedure"
        static let radiograph = "radiograph"
        static let designator = "designator"
    }
}
