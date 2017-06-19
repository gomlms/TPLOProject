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
    var tpa : Double?
    var sawbladeRadius : Double?
    var sawbladeSize : Int?
    var sawCatalogNumber : String?
    var chordLength : Double?
    var plateCatalogNumber : String?
    var pixelToMMRatio : Double?
    var designator : String?
    var roundedRadius : Int?
    var alpha : Double?
    var rotatedRadiograph : UIView?
    var imageViewWidth : CGFloat = 0
    var imageViewHeight : CGFloat = 0
    var imageViewXOrigin : CGFloat = 0
    var imageViewYOrigin : CGFloat = 0
    var savedImage : UIImage?
    var plateImageView : UIImageView?
    var secondImageView : UIImageView?
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let ArchiveURL = DocumentsDirectory?.appendingPathComponent("procedures")
    
    //MARK: Initialization
    init?(n:String, r:UIImage?, d:String, m:String, p1: [CGPoint], i1: String, s1: Double, s2: Int, s3: String, c1: Double, p2: String, p3: Double, r1: Int, a1: Double, r2: UIView, s4: UIImage?, i2: CGFloat, i3: CGFloat, i4: CGFloat, i5: CGFloat, p4: UIImageView?, t1: Double){
        guard !n.isEmpty else {
            return nil
        }
        
        name = n
        radiograph = r
        dateOfProcedure = d
        designator = m
        points = p1
        intersectionPoint = CGPointFromString(i1)
        sawbladeRadius = s1
        sawbladeSize = s2
        sawCatalogNumber = s3
        chordLength = c1
        plateCatalogNumber = p2
        pixelToMMRatio = p3
        roundedRadius = r1
        alpha = a1
        rotatedRadiograph = r2
        savedImage = s4
        imageViewWidth = i2
        imageViewHeight = i3
        imageViewXOrigin = i4
        imageViewYOrigin = i5
        plateImageView = p4
        tpa = t1
    }
    
    
    //MARK: NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(dateOfProcedure, forKey: PropertyKey.dateOfProcedure)
        aCoder.encode(radiograph, forKey: PropertyKey.radiograph)
        aCoder.encode(designator, forKey: PropertyKey.designator)
        aCoder.encode(points, forKey: PropertyKey.points)
        aCoder.encode(intersectionPoint, forKey: PropertyKey.intersectionPoint)
        aCoder.encode(sawbladeRadius, forKey: PropertyKey.sawbladeRadius)
        aCoder.encode(sawbladeSize, forKey: PropertyKey.sawbladeSize)
        aCoder.encode(sawCatalogNumber, forKey: PropertyKey.sawCatalogNumber)
        aCoder.encode(chordLength, forKey: PropertyKey.chordLength)
        aCoder.encode(plateCatalogNumber, forKey: PropertyKey.plateCatalogNumber)
        aCoder.encode(pixelToMMRatio, forKey: PropertyKey.pixelToMMRatio)
        aCoder.encode(roundedRadius, forKey: PropertyKey.roundedRadius)
        aCoder.encode(alpha, forKey: PropertyKey.alpha)
        aCoder.encode(rotatedRadiograph, forKey: PropertyKey.rotatedRadiograph)
        aCoder.encode(savedImage, forKey: PropertyKey.savedImage)
        aCoder.encode(imageViewWidth, forKey: PropertyKey.imageViewWidth)
        aCoder.encode(imageViewHeight, forKey: PropertyKey.imageViewHeight)
        aCoder.encode(imageViewXOrigin, forKey: PropertyKey.imageViewXOrigin)
        aCoder.encode(imageViewYOrigin, forKey: PropertyKey.imageViewYOrigin)
        aCoder.encode(plateImageView, forKey: PropertyKey.plateImageView)
        aCoder.encode(tpa, forKey: PropertyKey.tpa)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else{
            os_log("Unable to decode name of radiograph", log: OSLog.default, type:.debug)
            return nil
        }
        
        let dateOfProcedure = aDecoder.decodeObject(forKey: PropertyKey.dateOfProcedure) as! String
        let radiograph = aDecoder.decodeObject(forKey: PropertyKey.radiograph) as? UIImage
        let designator = aDecoder.decodeObject(forKey: PropertyKey.designator) as! String
        let points = aDecoder.decodeObject(forKey: PropertyKey.points) as! [CGPoint]
        let intersectionPoint = aDecoder.decodeObject(forKey: PropertyKey.intersectionPoint) as! String
        let sawbladeRadius = aDecoder.decodeObject(forKey: PropertyKey.sawbladeRadius) as! Double
        let sawbladeSize = aDecoder.decodeObject(forKey: PropertyKey.sawbladeSize) as! Int
        let sawCatalogNumber = aDecoder.decodeObject(forKey: PropertyKey.sawCatalogNumber) as! String
        let chordLength = aDecoder.decodeObject(forKey: PropertyKey.chordLength) as! Double
        let plateCatalogNumber = aDecoder.decodeObject(forKey: PropertyKey.plateCatalogNumber) as! String
        let pixelToMMRatio = aDecoder.decodeObject(forKey: PropertyKey.pixelToMMRatio) as! Double
        let roundedRadius = aDecoder.decodeObject(forKey: PropertyKey.roundedRadius) as! Int
        let alpha = aDecoder.decodeObject(forKey: PropertyKey.alpha) as! Double
        let rotatedRadiograph = aDecoder.decodeObject(forKey: PropertyKey.rotatedRadiograph) as! UIView
        let savedImage = aDecoder.decodeObject(forKey: PropertyKey.savedImage) as? UIImage
        let imageViewHeight = aDecoder.decodeObject(forKey: PropertyKey.imageViewHeight) as! CGFloat
        let imageViewWidth = aDecoder.decodeObject(forKey: PropertyKey.imageViewWidth) as! CGFloat
        let imageViewXOrigin = aDecoder.decodeObject(forKey: PropertyKey.imageViewXOrigin) as! CGFloat
        let imageViewYOrigin = aDecoder.decodeObject(forKey: PropertyKey.imageViewYOrigin) as! CGFloat
        let plateImageView = aDecoder.decodeObject(forKey: PropertyKey.plateImageView) as? UIImageView
        let tpa = aDecoder.decodeObject(forKey: PropertyKey.tpa) as! Double
    
        self.init(n: name, r: radiograph, d: dateOfProcedure, m: designator, p1: points, i1: intersectionPoint, s1: sawbladeRadius, s2: sawbladeSize, s3: sawCatalogNumber, c1: chordLength, p2: plateCatalogNumber, p3: pixelToMMRatio, r1: roundedRadius, a1: alpha, r2: rotatedRadiograph, s4: savedImage, i2: imageViewWidth, i3: imageViewHeight, i4: imageViewXOrigin, i5: imageViewYOrigin, p4: plateImageView, t1: tpa)
    }
    
    //MARK: Types
    struct PropertyKey{
        static let name = "name"
        static let dateOfProcedure = "dateOfProcedure"
        static let radiograph = "radiograph"
        static let designator = "designator"
        static let points = "points"
        static let intersectionPoint = "intersectionPoint"
        static let sawbladeRadius = "sawbladeRadius"
        static let sawbladeSize = "sawbladeSize"
        static let sawCatalogNumber = "sawCatalogNumber"
        static let chordLength = "chordLength"
        static let plateCatalogNumber = "plateCatalogNumber"
        static let pixelToMMRatio = "pixelToMMRatio"
        static let roundedRadius = "roundedRadius"
        static let alpha = "alpha"
        static let rotatedRadiograph = "rotatedRadiograph"
        static let savedImage = "savedImage"
        static let imageViewHeight = "imageViewHeight"
        static let imageViewWidth = "imageViewWidth"
        static let imageViewXOrigin = "imageViewXOrigin"
        static let imageViewYOrigin = "imageViewYOrigin"
        static let plateImageView = "plateImageView"
        static let tpa = "tpa"
    }
}
