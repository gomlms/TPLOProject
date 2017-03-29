//
//  TPAViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Erik Melone on 2/8/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class TPAViewController: UIViewController {

    //MARK: Properties
    
    var procedure: Procedure?
    
    var imageView = UIImageView()
    
    var dot1 = UIImageView(image: #imageLiteral(resourceName: "dot1"))
    var dot2 = UIImageView(image: #imageLiteral(resourceName: "dot2"))
    var dot3 = UIImageView(image: #imageLiteral(resourceName: "dot3"))
    var dot4 = UIImageView(image: #imageLiteral(resourceName: "dot4"))
    var dot5 = UIImageView(image: #imageLiteral(resourceName: "dot5"))
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var tpaLabel: UILabel!
    
    var imageViewWidth: CGFloat = 0.0, imageViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewWidth = procedure!.imageViewWidth
        imageViewHeight = procedure!.imageViewHeight
        
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        imageView.frame = CGRect(x: (screenWidth - imageViewWidth) / 2, y: (navigationController?.navigationBar.frame.height)! + 30, width: imageViewWidth, height: imageViewHeight)
        
        imageView.isUserInteractionEnabled = false
        imageView.image = procedure?.radiograph
        
        self.view.addSubview(imageView)
        imageView.addSubview(dot1)
        imageView.addSubview(dot2)
        imageView.addSubview(dot3)
        imageView.addSubview(dot4)
        imageView.addSubview(dot5)
        
        dot1.frame = CGRect(x: (procedure?.points[0].x)! - 5, y: (procedure?.points[0].y)! - 5, width: 10, height: 10)
        dot1.isHidden = false
        dot2.frame = CGRect(x: (procedure?.points[1].x)! - 5, y: (procedure?.points[1].y)! - 5, width: 10, height: 10)
        dot2.isHidden = false
        dot3.frame = CGRect(x: (procedure?.points[2].x)! - 5, y: (procedure?.points[2].y)! - 5, width: 10, height: 10)
        dot3.isHidden = false
        dot4.frame = CGRect(x: (procedure?.points[3].x)! - 5, y: (procedure?.points[3].y)! - 5, width: 10, height: 10)
        dot4.isHidden = false
        dot5.frame = CGRect(x: (procedure?.points[4].x)! - 5, y: (procedure?.points[4].y)! - 5, width: 10, height: 10)
        dot5.isHidden = false
        
        drawSetOfLines()
        procedure?.intersectionPoint = determineIntersection()
        procedure?.tpa = getAngle()
        let angle = procedure?.tpa
        
        tpaLabel.text = String(format: "TPA: %.2f°", angle!)
        
        // Do any additional setup after loading the view.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Finding Angle
    func drawSetOfLines() {
        let size = imageView.image?.size
        let lines = UIImageView(frame: CGRect(origin: CGPoint(x: 0 , y: 0), size: size!))
        imageView.addSubview(lines)
        
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size!, opaque, scale)
        guard let context = UIGraphicsGetCurrentContext() else { fatalError() }
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(1.0)
        
        context.beginPath()
        context.move(to: (procedure?.points[0])!)
        context.addLine(to: (procedure?.points[1])!)
        context.move(to: (procedure?.points[2])!)
        context.addLine(to: (procedure?.points[3])!)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lines.image = image
    }
    
    func determineIntersection() -> CGPoint {
        let d01 = ((procedure?.points[1].x)! - (procedure?.points[0].x)!) * ((procedure?.points[3].y)! - (procedure?.points[2].y)!)
        let d02 = ((procedure?.points[1].y)! - (procedure?.points[0].y)!) * ((procedure?.points[3].x)! - (procedure?.points[2].x)!)
        let distance = d01 - d02
        
        if distance == 0 {
            print("error, parallel lines")
            return CGPoint.zero
        }
        
        let u01 = ((procedure?.points[2].x)! - (procedure?.points[0].x)!) * ((procedure?.points[3].y)! - (procedure?.points[2].y)!)
        let u02 = ((procedure?.points[2].y)! - (procedure?.points[0].y)!) * ((procedure?.points[3].x)! - (procedure?.points[2].x)!)
        let u = (u01 - u02) / distance
        
        let v01 = ((procedure?.points[2].x)! - (procedure?.points[0].x)!) * ((procedure?.points[1].y)! - (procedure?.points[0].y)!)
        let v02 = ((procedure?.points[2].y)! - (procedure?.points[0].y)!) * ((procedure?.points[1].x)! - (procedure?.points[0].x)!)
        let v = (v01 - v02) / distance
        
        if (u < 0.0 || u > 1.0) {
            print("error, intersection not inside line1")
            return CGPoint.zero
        }
        if (v < 0.0 || v > 1.0) {
            print("error, intersection not inside line2")
            return CGPoint.zero
        }
      
        var returnPoint = CGPoint(x: 0.0, y: 0.0)
        returnPoint.x = (procedure?.points[0].x)! + u * ((procedure?.points[1].x)! - (procedure?.points[0].x)!)
        returnPoint.y = (procedure?.points[0].y)! + u * ((procedure?.points[1].y)! - (procedure?.points[0].y)!)
        
        return returnPoint
    }
    
    func getAngle () -> Double {
        let angle2I = Double(atan2((procedure?.points[1].y)! - (procedure?.intersectionPoint.y)!, (procedure?.points[1].x)! - (procedure?.intersectionPoint.x)!))
        let angle4I = Double(atan2((procedure?.points[3].y)! - (procedure?.intersectionPoint.y)!, (procedure?.points[3].x)! - (procedure?.intersectionPoint.x)!))
        var angle = Double(angle2I - angle4I)
        angle = angle * (180.0 / M_PI)
        return angle
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let nextController = segue.destination as? SawbladeViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        nextController.procedure = procedure
    }
    

}
