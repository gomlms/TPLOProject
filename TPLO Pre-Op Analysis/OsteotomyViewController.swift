//
//  OsteotomyViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 2/6/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class OsteotomyViewController: UIViewController, UIScrollViewDelegate {

    //MARK: Properties
    var procedure : Procedure?
    var maskImage : UIImage?
    var angleWith4 : CGFloat?
    var angleWith5 : CGFloat?

    var tempAngle : Double = 0;
    
    var radiographImage = UIImageView()
    var backgroundImage = UIImageView()
    var rotatingView = UIView()
    var innerView = UIView()
    var scrollView = UIScrollView()
    
    @IBOutlet weak var chordLengthLabel: UILabel!
    
    var imageViewWidth: CGFloat = 0.0, imageViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let procedure = procedure else {
            fatalError("Procedure was not correctly passed to Osteotomy Controller")
        }
        
        imageViewWidth = procedure.imageViewWidth
        imageViewHeight = procedure.imageViewHeight
        
        
        _ = UIScreen.main.bounds.width
        _ = UIScreen.main.bounds.height
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        
        backgroundImage.isUserInteractionEnabled = false
        backgroundImage.image = procedure.radiograph
        
        rotatingView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        
        rotatingView.isUserInteractionEnabled = false
        
        radiographImage.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        
        radiographImage.isUserInteractionEnabled = false
        radiographImage.image = procedure.radiograph
        
        rotatingView.addSubview(radiographImage)
        
        innerView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        innerView.addSubview(backgroundImage)
        innerView.addSubview(rotatingView)
        
        scrollView.frame = CGRect(x: procedure.imageViewXOrigin, y: 0, width: imageViewWidth, height: imageViewHeight)
        scrollView.delegate = self
        scrollView.addSubview(innerView)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        self.view.addSubview(scrollView)
        
        
        
        
        //Creating Part that is being rotated
        
        let maskPath = drawMaskImage(size: (procedure.radiograph?.size)!)

        let maskLayer = CAShapeLayer()
        
        maskLayer.path = maskPath?.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        radiographImage.image = procedure.radiograph
        radiographImage.layer.mask = maskLayer
        
        //Cropping out portion of original
        
        backgroundImage.image = procedure.radiograph
        let subLayer = CAShapeLayer()
        subLayer.path = drawMaskImage(size: (procedure.radiograph?.size)!)?.cgPath
        subLayer.strokeColor = UIColor.gray.cgColor
        subLayer.lineWidth = 0.1
        subLayer.fillColor = UIColor.gray.cgColor
        
        backgroundImage.layer.addSublayer(subLayer)
        
        
        procedure.alpha = (procedure.tpa - 5.0) * Double.pi / 180
        procedure.chordLength = Double(round(2 * procedure.sawbladeRadius! * sin(procedure.alpha! / 2) * 10)/10)
        
        tempAngle = sin(procedure.alpha! / 2)
        
        radiographImage.layer.anchorPoint = CGPoint(x: CGFloat(procedure.points[0].x / radiographImage.frame.width), y: CGFloat(procedure.points[0].y) / radiographImage.frame.height)
        radiographImage.transform = radiographImage.transform.rotated(by: CGFloat(-tempAngle))
        rotatingView.center = procedure.points[0]

        
        chordLengthLabel.text = "Osteotomy Rotation = \(procedure.chordLength!)mm"
        
        view.bringSubview(toFront: chordLengthLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let nextController = segue.destination as? PlateSizeViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        nextController.procedure = procedure
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return innerView
    }
}
