//
//  TPAViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Erik Melone on 2/8/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class TPAViewController: UIViewController, UIScrollViewDelegate {

    //MARK: Properties
    
    var procedure: Procedure?
    var radiographImage = UIImage()
    
    var imageView = UIImageView()
    var scrollView = UIScrollView()
    var innerView = UIView()
    
    var dot1 = UIImageView(image: #imageLiteral(resourceName: "dot1"))
    var dot2 = UIImageView(image: #imageLiteral(resourceName: "dot2"))
    var dot3 = UIImageView(image: #imageLiteral(resourceName: "dot3"))
    var dot4 = UIImageView(image: #imageLiteral(resourceName: "dot4"))
    var dot5 = UIImageView(image: #imageLiteral(resourceName: "dot5"))
    
    var sawbladeRadiusMM : Double?
    var roundedRadius : Int?
    
    var imageViewWidth: CGFloat = 0.0, imageViewHeight: CGFloat = 0.0
    
    var lineLayer = CAShapeLayer()
    var circleLayer = CAShapeLayer()
    
    @IBOutlet weak var tpaLabel: UILabel!
    @IBOutlet weak var sawbladeLabel: UILabel!
    
    @IBOutlet weak var TPAButton: UIImageView!
    @IBOutlet weak var SawButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        dot2 = (procedure?.secondImageView)!

        
        imageViewWidth = procedure!.imageViewWidth
        imageViewHeight = procedure!.imageViewHeight
        
        radiographImage = (procedure?.radiograph)!
        
        scrollView.frame = CGRect(x: (procedure?.imageViewXOrigin)!, y: 0, width: imageViewWidth, height: imageViewHeight)
        
        scrollView.contentSize = CGSize(width: imageViewWidth, height: imageViewHeight)
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        scrollView.layer.zPosition = -10
        
        innerView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        scrollView.addSubview(innerView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        imageView.isUserInteractionEnabled = false
        imageView.image = radiographImage
        innerView.addSubview(imageView)
        
        innerView.addSubview(imageView)
        scrollView.addSubview(innerView)
        
        self.view.addSubview(scrollView)
        
        imageView.addSubview(dot1)
        imageView.addSubview(dot2)
        imageView.addSubview(dot3)
        imageView.addSubview(dot4)
        imageView.addSubview(dot5)
        
        dot1.frame = CGRect(x: (procedure?.points[0].x)! - 5, y: (procedure?.points[0].y)! - 5, width: 10, height: 10)
        dot1.isHidden = false
        dot2.frame = CGRect(x: (procedure?.points[1].x)! - ((procedure?.secondImageView?.frame.width)! / 2), y: (procedure?.points[1].y)! - ((procedure?.secondImageView?.frame.height)! / 2), width: (procedure?.secondImageView?.frame.width)!, height: (procedure?.secondImageView?.frame.height)!)
        dot2.isHidden = false
        dot3.frame = CGRect(x: (procedure?.points[2].x)! - 5, y: (procedure?.points[2].y)! - 5, width: 10, height: 10)
        dot3.isHidden = false
        dot4.frame = CGRect(x: (procedure?.points[3].x)! - 5, y: (procedure?.points[3].y)! - 5, width: 10, height: 10)
        dot4.isHidden = false
        dot5.frame = CGRect(x: (procedure?.points[4].x)! - 5, y: (procedure?.points[4].y)! - 5, width: 10, height: 10)
        dot5.isHidden = false
        
        procedure?.intersectionPoint = determineIntersection()
        drawSetOfLines()
        procedure?.tpa = getAngle()
        let angle = procedure?.tpa
        
        tpaLabel?.text = String(format: "%.2f°", (90 - angle!))
        
        self.scrollView.maximumZoomScale = 6.0
        self.scrollView.minimumZoomScale = 1.0
        scrollView.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
        
        imageView.bringSubview(toFront: dot1)
        imageView.bringSubview(toFront: dot2)
        imageView.bringSubview(toFront: dot3)
        imageView.bringSubview(toFront: dot4)
        imageView.bringSubview(toFront: dot5)
        
        //SAWBLADE-------------------------------------------------------------------------------
        
        let xSquared = Double(pow(((procedure?.points[4].x)! - (procedure?.points[0].x)!), 2))
        
        let ySquared = Double(pow(((procedure?.points[4].y)! - (procedure?.points[0].y)!), 2))
        
        procedure?.sawbladeRadius = sqrt(xSquared + ySquared)
        
        sawbladeRadiusMM = (procedure?.sawbladeRadius)! / (procedure?.pixelToMMRatio)!
        
        if(sawbladeRadiusMM! < 16.5){
            roundedRadius = 15
        } else if(sawbladeRadiusMM! > 16.5 && sawbladeRadiusMM! <= 19.5) {
            roundedRadius = 18
        } else if(sawbladeRadiusMM! > 19.5 && sawbladeRadiusMM! <= 22.5) {
            roundedRadius = 21
        } else if(sawbladeRadiusMM! > 22.5 && sawbladeRadiusMM! <= 25.5) {
            roundedRadius = 24
        } else if(sawbladeRadiusMM! > 25.5 && sawbladeRadiusMM! <= 28.5) {
            roundedRadius = 27
        } else {
            roundedRadius = 30
        }
        
        procedure?.roundedRadius = roundedRadius
        
        drawSawbladeCircle()
        sawbladeLabel?.text = String(format: "%dmm", roundedRadius!)
        
        view.bringSubview(toFront: TPAButton)
        view.bringSubview(toFront: SawButton)
    }
    
    func drawSawbladeCircle(){
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions((imageView.image?.size)!, opaque, scale)
        
        let sawbladeCircle = UIBezierPath()
        
        sawbladeCircle.addArc(withCenter: CGPoint(x: (procedure?.intersectionPoint.x)!, y: (procedure?.intersectionPoint.y)!), radius: CGFloat(Float(Double(roundedRadius!) * (procedure?.pixelToMMRatio)!)), startAngle: 0.0, endAngle: CGFloat(2.0 * 3.141592), clockwise: true)
        
        UIGraphicsEndImageContext()
        
        circleLayer = CAShapeLayer()
        
        circleLayer.bounds = imageView.frame
        
        circleLayer.position = CGPoint(x: 0, y: 0)
        circleLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        circleLayer.path = sawbladeCircle.cgPath
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 1.0
        circleLayer.fillColor = UIColor.clear.cgColor
        
        circleLayer.strokeEnd = 0.0
        
        imageView.layer.addSublayer(circleLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        
        animation.fromValue = 0.0
        animation.toValue = 1.0
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        circleLayer.strokeEnd = 1.0
        
        circleLayer.add(animation, forKey:"strokeEnd")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TPAPress(_ sender: Any) {
        if(!lineLayer.isHidden){
            UIView.animate(withDuration: 1, animations: {
                self.lineLayer.isHidden = true
            })
            TPAButton.image = #imageLiteral(resourceName: "TPAButtonGray")
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.lineLayer.isHidden = false
            })
            TPAButton.image = #imageLiteral(resourceName: "TPAButtonBlue")
        }
    }
    
    @IBAction func SawPress(_ sender: Any) {
        if(!circleLayer.isHidden){
            UIView.animate(withDuration: 1, animations: {
                self.circleLayer.isHidden = true
            })
            SawButton.image = #imageLiteral(resourceName: "SawButtonGray")
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.circleLayer.isHidden = false
            })
            SawButton.image = #imageLiteral(resourceName: "SawbladeButtonBlue")
        }
    }
    
    
    //MARK: Finding Angle
    func drawSetOfLines() {
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions((imageView.image?.size)!, opaque, scale)
        
        let lines = UIBezierPath()
        
        lines.move(to: (procedure?.points[0])!)
        lines.addLine(to: (procedure?.points[1])!)
        lines.move(to: (procedure?.points[2])!)
        lines.addLine(to: (procedure?.points[3])!)
        
        lines.move(to: (procedure?.intersectionPoint)!)
        lines.addArc(withCenter: (procedure?.intersectionPoint)!, radius: 20, startAngle: CGFloat(getNewAngle()), endAngle: CGFloat(getOtherAngle()), clockwise: false)
        
        lineLayer = CAShapeLayer()
        
        lineLayer.bounds = imageView.frame
        
        lineLayer.position = CGPoint(x: 0, y: 0)
        lineLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        lineLayer.path = lines.cgPath
        lineLayer.strokeColor = UIColor.red.cgColor
        lineLayer.lineWidth = 1.0
        
        lineLayer.strokeEnd = 0.0
        
        imageView.layer.addSublayer(lineLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        
        animation.fromValue = 0.0
        animation.toValue = 1.0
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        lineLayer.strokeEnd = 1.0
        
        lineLayer.add(animation, forKey: "strokeEnd")
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
        angle = angle * (180.0 / Double.pi)
        return angle
    }
    
    func getNewAngle () -> Double {
        let angle2I = Double(atan2((procedure?.points[1].y)! - (procedure?.intersectionPoint.y)!, (procedure?.points[1].x)! - (procedure?.intersectionPoint.x)!))
        let angle4I = Double(atan2((procedure?.intersectionPoint.y)! - (procedure?.intersectionPoint.y)!, ((procedure?.intersectionPoint.x)! + 30) - (procedure?.intersectionPoint.x)!))
        var angle = Double(angle2I - angle4I)
        return angle
    }
    
    func getOtherAngle () -> Double {
        let angle2I = Double(atan2((procedure?.points[3].y)! - (procedure?.intersectionPoint.y)!, (procedure?.points[3].x)! - (procedure?.intersectionPoint.x)!))
        let angle4I = Double(atan2((procedure?.intersectionPoint.y)! - (procedure?.intersectionPoint.y)!, ((procedure?.intersectionPoint.x)! + 30) - (procedure?.intersectionPoint.x)!))
        var angle = Double(angle2I - angle4I)
        return angle
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let nextController = segue.destination as? OsteotomyViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        nextController.procedure = procedure
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        /*
         if(firstHeight){
         prevHeight = self.innerView.frame.height
         firstHeight = false
         }
         
         let hRatio =  self.innerView.frame.height / prevHeight
         print(hRatio)
         
         if(prevHeight != self.innerView.frame.height) {
         dot1ImageView.frame = CGRect(x: dot1ImageView.frame.origin.x, y: dot1ImageView.frame.origin.y, width: dot1ImageView.frame.size.width / hRatio, height: dot1ImageView.frame.size.height / hRatio)
         dot1ImageView.center = points[0]
         
         dot2ImageView.frame = CGRect(x: dot2ImageView.frame.origin.x, y: dot2ImageView.frame.origin.y, width: dot2ImageView.frame.size.width / hRatio, height: dot2ImageView.frame.size.height / hRatio)
         dot2ImageView.center = points[1]
         }
         prevHeight = self.innerView.frame.height
         */
        return innerView
    }
    

}
