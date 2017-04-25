//
//  SummaryViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 2/28/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit
import MessageUI

class SummaryViewController: UIViewController, MFMailComposeViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var hideButton: UIImageView!
    var procedure : Procedure?
    var isThere = false
    
    var rotatingView = UIView()
    var radiographView = UIImageView()
    var backgroundView = UIImageView()
    var innerView = UIView()
    var scrollView = UIScrollView()
    
    var tempAngle : Double = 0
    var angleWith4 : CGFloat?
    var angleWith5 : CGFloat?
    var maskImage : UIImage?
    
    var imageViewHeight: CGFloat = 0.0, imageViewWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        
        guard let procedure = procedure else {
            fatalError("Procedure was not correctly passed to Summary Controller")
        }
        
        imageViewWidth = procedure.imageViewWidth
        imageViewHeight = procedure.imageViewHeight
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        
        backgroundView.isUserInteractionEnabled = false
        backgroundView.image = procedure.radiograph
        
        rotatingView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        
        rotatingView.isUserInteractionEnabled = false
        
        self.view.addSubview(rotatingView)
        
        radiographView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        
        radiographView.isUserInteractionEnabled = false
        radiographView.image = procedure.radiograph
        
        rotatingView.addSubview(radiographView)
        
        innerView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        innerView.addSubview(backgroundView)
        innerView.addSubview(rotatingView)
        
        scrollView.frame = CGRect(x: procedure.imageViewXOrigin, y: 0, width: imageViewWidth, height: imageViewHeight)
        scrollView.delegate = self
        scrollView.addSubview(innerView)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        self.view.addSubview(scrollView)
        scrollView.isUserInteractionEnabled = false
        //Creating Part that is Being Rotated
        
        let maskPath = drawMaskImage(size: (procedure.radiograph?.size)!)
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = maskPath?.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        radiographView.image = procedure.radiograph
        radiographView.layer.mask = maskLayer
        
        scrollView.isUserInteractionEnabled = true
        
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
        
        self.view.sendSubview(toBack: scrollView)
        
        procedure.tpa = getAngle()
        
        outputLabel.text = String(format: "Date: \(procedure.dateOfProcedure)\nPatient Name: \((procedure.name)!)\nTPA: %.2f°\nOsteotomy Rotation: \((procedure.chordLength)!)mm\nSawblade Size: \((procedure.roundedRadius)!)mm\nPlate Size: \((procedure.plateCatalogNumber)!)", procedure.tpa)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmailPressed(_ sender: Any) {
        if(MFMailComposeViewController.canSendMail()){
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setSubject("TPLO Pre-Op Analysis Summary Report")
            mailComposer.setMessageBody("Date: \(String(describing: procedure?.dateOfProcedure))\nPatient Name: \((procedure?.name)!)\nTPA: \(String(describing: procedure?.tpa))°\nOsteotomy Rotation: \((procedure?.chordLength)!)mm\nSawblade Size: \((procedure?.roundedRadius)!)mm\nPlate Size: \((procedure?.plateCatalogNumber)!)", isHTML: false)
            
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "StartScreen":
            guard let startViewController = segue.destination as? MainScreenViewController else {
                fatalError("Unexpected Destination: \(segue.destination)")
            }
            if(!isThere){
                startViewController.procedures.append(procedure!)
            }
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }
    }
    
    func getAngle () -> Double {
        let angle2I = Double(atan2((procedure?.points[1].y)! - (procedure?.intersectionPoint.y)!, (procedure?.points[1].x)! - (procedure?.intersectionPoint.x)!))
        let angle4I = Double(atan2((procedure?.points[3].y)! - (procedure?.intersectionPoint.y)!, (procedure?.points[3].x)! - (procedure?.intersectionPoint.x)!))
        var angle = Double(angle2I - angle4I)
        angle = angle * (180.0 / Double.pi)
        return angle
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return innerView
    }
    
    @IBAction func hideText(_ sender: Any) {
        if(!outputLabel.isHidden){
            outputLabel.isHidden = true;
            hideButton.image = #imageLiteral(resourceName: "HideGreyButton")
        } else {
            outputLabel.isHidden = false
            hideButton.image = #imageLiteral(resourceName: "HideBlueButton")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
