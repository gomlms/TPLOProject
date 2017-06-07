//
//  SetSawbladeViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 6/7/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class SetSawbladeViewController: UIViewController, UIScrollViewDelegate {

    var procedure : Procedure?
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        procedure?.tpa = 90 - angle!
        
        self.scrollView.maximumZoomScale = 6.0
        self.scrollView.minimumZoomScale = 1.0
        scrollView.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
        
        imageView.bringSubview(toFront: dot1)
        imageView.bringSubview(toFront: dot2)
        imageView.bringSubview(toFront: dot3)
        imageView.bringSubview(toFront: dot4)
        imageView.bringSubview(toFront: dot5)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let angle = Double(angle2I - angle4I)
        return angle
    }
    
    func getOtherAngle () -> Double {
        let angle2I = Double(atan2((procedure?.points[3].y)! - (procedure?.intersectionPoint.y)!, (procedure?.points[3].x)! - (procedure?.intersectionPoint.x)!))
        let angle4I = Double(atan2((procedure?.intersectionPoint.y)! - (procedure?.intersectionPoint.y)!, ((procedure?.intersectionPoint.x)! + 30) - (procedure?.intersectionPoint.x)!))
        let angle = Double(angle2I - angle4I)
        return angle
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let nextController = segue.destination as? TPAViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        nextController.procedure = procedure
    }
    

}
