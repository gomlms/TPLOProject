//
//  PlateSizeViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 2/24/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class PlateSizeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var rotatingView = UIView()
    var radiographView = UIImageView()
    var backgroundView = UIImageView()
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
    
    var broad35 = [79, 28.4, 45, 135]
    var short35 = [56, 20, 31.5, 87.5]
    var standard35 = [65, 21.67, 34, 101.5]
    var desiredWidth: Double = 0.0
    var desiredHeight: Double = 0.0
    var currentImageName: String = ""
    
    @IBOutlet weak var rotatingRecognizer: UIRotationGestureRecognizer!    
    @IBOutlet weak var movingRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var innerScrollView: UIView!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    var platePresent = false
    
    var imageViewHeight: CGFloat = 0.0, imageViewWidth: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let procedure = procedure else {
            fatalError("Procedure was not correctly passed to Plate Size Controller")
        }
        
        imageViewWidth = procedure.imageViewWidth
        imageViewHeight = procedure.imageViewHeight
        
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        backgroundView.frame = CGRect(x: (screenWidth - imageViewWidth) / 2, y: (navigationController?.navigationBar.frame.height)! + 30, width: imageViewWidth, height: imageViewHeight)
        
        backgroundView.isUserInteractionEnabled = false
        backgroundView.image = procedure.radiograph
        
        self.view.addSubview(backgroundView)
        
        rotatingView.frame = CGRect(x: (screenWidth - imageViewWidth) / 2, y: (navigationController?.navigationBar.frame.height)! + 30, width: imageViewWidth, height: imageViewHeight)
        
        rotatingView.isUserInteractionEnabled = false
        
        self.view.addSubview(rotatingView)
        
        radiographView.frame = CGRect(x: (screenWidth - imageViewWidth) / 2, y: (navigationController?.navigationBar.frame.height)! + 30, width: imageViewWidth, height: imageViewHeight)
        
        radiographView.isUserInteractionEnabled = false
        radiographView.image = procedure.radiograph
        
        rotatingView.addSubview(radiographView)
        
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
        rotatingView.center = procedure.points[0]
        
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
        
        procedure?.plateCatalogNumber = currentImageName
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
                if(movingImage.image == #imageLiteral(resourceName: "broad3.5(79mm)")) {
                    desiredHeight = broad35[0]
                    desiredWidth = broad35[1]
                    currentImageName = "broad35"
                } else if(movingImage.image == #imageLiteral(resourceName: "short3.5(56mm)")) {
                    desiredHeight = Double(short35[0])
                    desiredWidth = Double(short35[1])
                    currentImageName = "short35"
                } else if(movingImage.image == #imageLiteral(resourceName: "standard3.5(65mm)")) {
                    desiredHeight = standard35[0]
                    desiredWidth = standard35[1]
                    currentImageName = "standard35"
                }
                
                
                self.view.addGestureRecognizer(movingRecognizer)
                self.view.addGestureRecognizer(rotatingRecognizer)
                
                originOfActiveImage = movingImage.frame.origin
                
                movingImage.removeFromSuperview()
                movingImage.frame = CGRect(x: 100.0, y: 100.0, width: desiredWidth * (procedure?.pixelToMMRatio)!, height: desiredHeight * (procedure?.pixelToMMRatio)!)
                self.view.addSubview(movingImage)
                
                activeImage = movingImage
                imageInSuperview = true
            } else {
                if(movingImage == activeImage) {
                    self.view.removeGestureRecognizer(movingRecognizer)
                    self.view.removeGestureRecognizer(rotatingRecognizer)
                    
                    movingImage.removeFromSuperview()
                    movingImage.transform = movingImage.transform.rotated(by: -totalRotation)
                    
                    if(currentImageName == "broad35") {
                        movingImage.frame = CGRect(x: originOfActiveImage.x, y: originOfActiveImage.y, width: CGFloat(broad35[2]), height: CGFloat(broad35[3]))
                    } else if(currentImageName == "short35") {
                        movingImage.frame = CGRect(x: originOfActiveImage.x, y: originOfActiveImage.y, width: CGFloat(short35[2]), height: CGFloat(short35[3]))
                    } else if(currentImageName == "standard35") {
                        movingImage.frame = CGRect(x: originOfActiveImage.x, y: originOfActiveImage.y, width: CGFloat(standard35[2]), height: CGFloat(standard35[3]))
                    }
                    
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
        activeImage?.center = CGPoint(x: (activeImage?.center.x)! + translation.x, y: (activeImage?.center.y)! + translation.y)
        
        recognizer.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
    }
    
    @IBAction func handleRotate(recognizer: UIRotationGestureRecognizer) {
            activeImage?.transform = (activeImage?.transform.rotated(by: recognizer.rotation))!
            totalRotation += recognizer.rotation
            
            recognizer.rotation = 0
    }

    private func updateNextButtonState() {
        if platePresent {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
