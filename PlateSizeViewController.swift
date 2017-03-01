//
//  PlateSizeViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 2/24/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class PlateSizeViewController: UIViewController {
    
    @IBOutlet weak var rotatingView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var radiographView: UIImageView!
    @IBOutlet weak var backgroundView: UIImageView!
    var procedure : Procedure?
    
    var tempAngle : Double = 0
    var angleWith4 : CGFloat?
    var angleWith5 : CGFloat?
    var maskImage : UIImage?
    
    var imageInSuperview = false
    var originOfActiveImage = CGPoint.zero
    var activeImage: UIImageView?
    var totalRotation: CGFloat = 0.0
    var betterPxlToMM: Double = 0.0
    
    @IBOutlet weak var rotatingRecognizer: UIRotationGestureRecognizer!    
    @IBOutlet weak var movingRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var innerScrollView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let procedure = procedure else {
            fatalError("Procedure was not correctly passed to Plate Size Controller")
        }
        
        let maskPath = drawMaskImage(size: (procedure.radiograph?.size)!)
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = maskPath?.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        radiographView.image = procedure.radiograph
        radiographView.layer.mask = maskLayer
        
        //Cropping out portion of original

        
        backgroundView.image = procedure.radiograph
        let subLayer = CAShapeLayer()
        subLayer.path = drawMaskImage(size: (procedure.radiograph?.size)!)?.cgPath
        subLayer.strokeColor = UIColor.gray.cgColor
        subLayer.lineWidth = 0.1
        subLayer.fillColor = UIColor.gray.cgColor
        
        backgroundView.layer.addSublayer(subLayer)
        
        procedure.alpha = (procedure.tpa - 5.0) * Double.pi / 180
        procedure.chordLength = Double(round(2 * procedure.sawbladeRadius! * sin(procedure.alpha! / 2) * 10)/10)
        
        tempAngle = sin(procedure.alpha! / 2)
        
        radiographView.layer.anchorPoint = CGPoint(x: CGFloat(procedure.points[0].x / radiographView.frame.width), y: CGFloat(procedure.points[0].y) / radiographView.frame.height)
        radiographView.transform = radiographView.transform.rotated(by: CGFloat(-tempAngle))
        rotatingView.transform = rotatingView.transform.translatedBy(x: -150 + procedure.points[0].x, y: -150 + procedure.points[0].y)

        // Do any additional setup after loading the view.
    }
    
    func drawMaskImage(size: CGSize) -> UIBezierPath? {
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        
        let polygon = UIBezierPath()
        
        polygon.move(to: CGPoint(x: (procedure?.points[2].x)!, y: (procedure?.points[2].y)!))
        polygon.addLine(to: CGPoint(x: (procedure?.points[0].x)!, y: (procedure?.points[0].y)!))
        polygon.addLine(to: CGPoint(x: (procedure?.points[3].x)!, y: (procedure?.points[3].y)!))
        polygon.addLine(to: CGPoint(x: (procedure?.points[3].x)!, y: (getYOnCircle(xPoint: (procedure?.points[3].x)!))!))
        
        _ = getXOnCircle(yPoint: (procedure?.points[4].y)!);
        
        polygon.addArc(withCenter: CGPoint(x: (procedure?.points[0].x)!, y: (procedure?.points[0].y)!), radius: CGFloat(Float((procedure?.roundedRadius)!)), startAngle: angleWith4!, endAngle: CGFloat.pi, clockwise: true)
        
        polygon.move(to: CGPoint(x: (procedure?.points[4].x)!, y: (procedure?.points[4].y)!))
        polygon.addLine(to: CGPoint(x: (procedure?.points[2].x)!, y: (procedure?.points[2].y)!))
        
        polygon.close()
        polygon.stroke()
        
        //Fills shape with black
        polygon.fill()
        
        let sliceLayer = CALayer()
        sliceLayer.accessibilityPath = polygon
        
        sliceLayer.borderColor = UIColor.black.cgColor
        sliceLayer.backgroundColor = UIColor.white.cgColor
        
        sliceLayer.borderWidth = 10.0
        
        //let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return polygon
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let nextController = segue.destination as? SummaryViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        nextController.procedure = procedure
    }

    
    func getXOnCircle(yPoint : CGFloat) -> CGFloat? {
        var xPoint : CGFloat = 0
        var angle : Double = 1.0
        
        while(angle <= 360){
            var tempX = Double((procedure?.sawbladeRadius)! * cos(angle * Double.pi / 180))
            tempX += Double((procedure?.points[0].x)!)
            
            var tempY = Double((procedure?.sawbladeRadius)! * sin(angle * Double.pi / 180))
            tempY += Double((procedure?.points[0].y)!)
            
            if(abs(CGFloat(tempY) - yPoint) < 0.5){
                xPoint = CGFloat(tempX)
                if(CGFloat(angle * Double.pi / 180) > 1.4){
                    break;
                }
            }
            
            angle += 0.5
        }
        
        angleWith5 = CGFloat(angle * Double.pi / 180);
        
        return xPoint
    }
    
    func getYOnCircle(xPoint : CGFloat) -> CGFloat? {
        var yPoint : CGFloat = 0
        var angle : Double = 1.0
        
        while(angle <= 360){
            var tempY = Double((procedure?.sawbladeRadius)! * sin(angle * Double.pi / 180))
            tempY += Double((procedure?.points[0].y)!)
            
            var tempX = Double((procedure?.sawbladeRadius)! * cos(angle * Double.pi / 180))
            tempX += Double((procedure?.points[0].x)!)
            
            if(abs(CGFloat(tempX) - xPoint) < 0.5){
                yPoint = CGFloat(tempY)
                break;
            }
            
            angle += 0.5
        }
        
        angleWith4 = CGFloat(angle * Double.pi / 180);
        
        return yPoint
    }
    
    @IBAction func handleTap(recognizer: UITapGestureRecognizer) {
        if let movingImage = recognizer.view as! UIImageView? {
            if(!imageInSuperview) {
                movingImage.addGestureRecognizer(movingRecognizer)
                movingImage.addGestureRecognizer(rotatingRecognizer)
                
                originOfActiveImage = movingImage.frame.origin
                
                movingImage.removeFromSuperview()
                movingImage.center = CGPoint(x: 150, y: 150)
                self.view.addSubview(movingImage)
                
                activeImage = movingImage
                imageInSuperview = true
            } else {
                if(movingImage == activeImage) {
                    movingImage.removeGestureRecognizer(movingRecognizer)
                    movingImage.removeGestureRecognizer(rotatingRecognizer)
                    
                    movingImage.removeFromSuperview()
                    movingImage.transform = movingImage.transform.rotated(by: -totalRotation)
                    movingImage.frame.origin = originOfActiveImage
                    innerScrollView.addSubview(movingImage)
                    
                    originOfActiveImage = CGPoint.zero
                    activeImage = nil
                    imageInSuperview = false
                    totalRotation = 0.0
                }
            }
        }
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let movingView = recognizer.view as! UIImageView? {
            if(movingView == activeImage) {
                movingView.center = CGPoint(x: movingView.center.x + translation.x, y: movingView.center.y + translation.y)
            }
        }
        recognizer.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
    }
    
    @IBAction func handleRotate(recognizer: UIRotationGestureRecognizer) {
        if let movingView = recognizer.view as! UIImageView? {
            movingView.transform = movingView.transform.rotated(by: recognizer.rotation)
            totalRotation += recognizer.rotation
            
            recognizer.rotation = 0
        }
    }
    
    func determineBetterRatio() {
        if(procedure?.designator == "Ball") {
            betterPxlToMM = (procedure?.pixelToMMRatio)! / 25.0
        } else if(procedure?.designator == "Marker") {
            betterPxlToMM = (procedure?.pixelToMMRatio)! / 100.0
        }
    }
}
