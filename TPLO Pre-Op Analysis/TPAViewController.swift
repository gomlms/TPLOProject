//
//  TPAViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Erik Melone on 2/8/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class TPAViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    //MARK: Properties
    
    var procedure: Procedure?
    var radiographImage = UIImage()
    
    var imageView = UIImageView()
    var scrollView = UIScrollView()
    var innerView = UIView()
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var menuView: UIImageView!
    var dot1 = UIImageView(image: #imageLiteral(resourceName: "dot1"))
    var dot2 = UIImageView(image: #imageLiteral(resourceName: "dot2"))
    var dot3 = UIImageView(image: #imageLiteral(resourceName: "dot3"))
    var dot4 = UIImageView(image: #imageLiteral(resourceName: "dot4"))
    var dot5 = UIImageView(image: #imageLiteral(resourceName: "dot5"))
    
    @IBOutlet weak var tpaBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBotConstraint: NSLayoutConstraint!
    var sawbladeRadiusMM : Double?
    var roundedRadius : Int?
    
    @IBOutlet weak var plusButton: UIImageView!
    @IBOutlet weak var plusBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBotConstraint: NSLayoutConstraint!
    var imageViewWidth: CGFloat = 0.0, imageViewHeight: CGFloat = 0.0
    
    var lineLayer = CAShapeLayer()
    var circleLayer = CAShapeLayer()
    
    @IBOutlet weak var tpaLabel: UILabel!
    @IBOutlet weak var sawbladeLabel: UILabel!
    
    @IBOutlet weak var TPAButton: UIImageView!
    
    
    var point1Button = UIView()
    var point2Button = UIView()
    var point3Button = UIView()
    var point31Button = UIView()
    var point4Button = UIView()
    var point5Button = UIView()
    var confirmSelection = UIView()
    var point8Button = UIView()
    
    var button1Recog = UITapGestureRecognizer()
    var button2Recog = UITapGestureRecognizer()
    var button3Recog = UITapGestureRecognizer()
    var button31Recog = UITapGestureRecognizer()
    var button4Recog = UITapGestureRecognizer()
    var button5Recog = UITapGestureRecognizer()
    var confirmRecog = UITapGestureRecognizer()
    var button8Recog = UITapGestureRecognizer()
    
    var selectedColor : UIColor = UIColor(red:0.00, green:0.74, blue:0.89, alpha:0.7)
    var unselectedColor : UIColor = UIColor(red:0.00, green:0.32, blue:0.61, alpha:0.7)
    var greyColor : UIColor = UIColor(red:0.27, green:0.35, blue:0.34, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        
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
        
        tpaLabel?.text = "\(Int(round(90-angle!)))°"
        
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
        
        /*//SAWBLADE-------------------------------------------------------------------------------
        
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
        sawbladeLabel?.text = String(format: "%dmm", roundedRadius!)*/
        
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = screenWidth / 4.0
        
        point1Button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot1Label = UILabel(frame: CGRect(x: buttonWidth / 15, y: buttonWidth / 3, width: buttonWidth * 5 / 6, height: 60))
        dot1Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot1Label.numberOfLines = 0
        dot1Label.font = UIFont(name:"Open Sans", size: 20)
        dot1Label.textColor = UIColor.white
        dot1Label.textAlignment = .center
        dot1Label.text = "12mm\n Sawblade"
        
        point1Button.layer.borderColor = UIColor.gray.cgColor
        point1Button.layer.borderWidth = 2.0
        point1Button.layer.shadowRadius = 10.0
        point1Button.addSubview(dot1Label)
        
        menuView.addSubview(point1Button)
        
        point2Button.frame = CGRect(x: buttonWidth, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot2Label = UILabel(frame: CGRect(x: buttonWidth / 15, y: buttonWidth / 3, width: buttonWidth * 5 / 6, height: 60))
        dot2Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot2Label.numberOfLines = 0
        dot2Label.font = UIFont(name:"Open Sans", size: 16)
        dot2Label.textColor = UIColor.white
        dot2Label.textAlignment = .center
        dot2Label.text = "15mm\n Sawblade"
        
        point2Button.layer.borderColor = UIColor.gray.cgColor
        point2Button.layer.borderWidth = 2.0
        point2Button.layer.shadowRadius = 10.0
        
        point2Button.addSubview(dot2Label)
        
        menuView.addSubview(point2Button)
        
        point3Button.frame = CGRect(x: 2 * buttonWidth, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot3Label = UILabel(frame: CGRect(x: buttonWidth / 15, y: buttonWidth / 3, width: buttonWidth * 5 / 6, height: 60))
        dot3Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot3Label.numberOfLines = 0
        dot3Label.font = UIFont(name:"Open Sans", size: 16)
        dot3Label.textColor = UIColor.white
        dot3Label.textAlignment = .center
        dot3Label.text = "18mm\n Sawblade"
        
        point3Button.layer.borderColor = UIColor.gray.cgColor
        point3Button.layer.borderWidth = 2.0
        point3Button.layer.shadowRadius = 10.0
        
        point3Button.addSubview(dot3Label)
        
        menuView.addSubview(point3Button)
        
        point31Button.frame = CGRect(x: 3 * buttonWidth, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot31Label = UILabel(frame: CGRect(x: buttonWidth / 15, y: buttonWidth / 3, width: buttonWidth * 5 / 6, height: 60))
        dot31Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot31Label.numberOfLines = 0
        dot31Label.font = UIFont(name:"Open Sans", size: 16)
        dot31Label.textColor = UIColor.white
        dot31Label.textAlignment = .center
        dot31Label.text = "21mm\n Sawblade"
        
        point31Button.layer.borderColor = UIColor.gray.cgColor
        point31Button.layer.borderWidth = 2.0
        point31Button.layer.shadowRadius = 10.0
        
        point31Button.addSubview(dot31Label)
        
        menuView.addSubview(point31Button)
        
        
        point4Button.frame = CGRect(x: 0, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot4Label = UILabel(frame: CGRect(x: buttonWidth / 15, y: buttonWidth / 3, width: buttonWidth * 5 / 6, height: 60))
        dot4Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot4Label.numberOfLines = 0
        dot4Label.font = UIFont(name:"Open Sans", size: 16)
        dot4Label.textColor = UIColor.white
        dot4Label.textAlignment = .center
        dot4Label.text = "24mm\n Sawblade"
        
        point4Button.layer.borderColor = UIColor.gray.cgColor
        point4Button.layer.borderWidth = 2.0
        point4Button.layer.shadowRadius = 10.0
        
        point4Button.addSubview(dot4Label)
        
        menuView.addSubview(point4Button)
        
        point5Button.frame = CGRect(x: buttonWidth, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot5Label = UILabel(frame: CGRect(x: buttonWidth / 15, y: buttonWidth / 3, width: buttonWidth * 5 / 6, height: 60))
        dot5Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot5Label.numberOfLines = 0
        dot5Label.font = UIFont(name:"Open Sans", size: 16)
        dot5Label.textColor = UIColor.white
        dot5Label.textAlignment = .center
        dot5Label.text = "27mm\n Sawblade"
        
        point5Button.layer.borderColor = UIColor.gray.cgColor
        point5Button.layer.borderWidth = 2.0
        point5Button.layer.shadowRadius = 10.0
        
        point5Button.addSubview(dot5Label)
        
        menuView.addSubview(point5Button)
        
        confirmSelection.frame = CGRect(x: 2 * buttonWidth, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let confirmLabel = UILabel(frame: CGRect(x: buttonWidth / 15, y: buttonWidth / 3, width: buttonWidth * 5 / 6, height: 60))
        confirmLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        confirmLabel.numberOfLines = 0
        confirmLabel.font = UIFont(name:"Open Sans", size: 16)
        confirmLabel.textColor = UIColor.white
        confirmLabel.textAlignment = .center
        confirmLabel.text = "30mm\n Sawblade"
        
        confirmSelection.layer.borderColor = UIColor.gray.cgColor
        confirmSelection.layer.borderWidth = 2.0
        confirmSelection.layer.shadowRadius = 10.0
        
        confirmSelection.addSubview(confirmLabel)
        
        menuView.addSubview(confirmSelection)
        
        point8Button.frame = CGRect(x: 3 * buttonWidth, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot8Label = UILabel(frame: CGRect(x: buttonWidth / 15, y: buttonWidth / 3, width: buttonWidth * 5 / 6, height: 60))
        dot8Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot8Label.numberOfLines = 0
        dot8Label.font = UIFont(name:"Open Sans", size: 16)
        dot8Label.textColor = UIColor.white
        dot8Label.textAlignment = .center
        dot8Label.text = "33mm\n Sawblade"
        
        point8Button.layer.borderColor = UIColor.gray.cgColor
        point8Button.layer.borderWidth = 2.0
        point8Button.layer.shadowRadius = 10.0
        
        point8Button.addSubview(dot8Label)
        
        menuView.addSubview(point8Button)
        
        
        menuView.isUserInteractionEnabled = true
        point1Button.isUserInteractionEnabled = true
        point2Button.isUserInteractionEnabled = true
        point3Button.isUserInteractionEnabled = true
        point31Button.isUserInteractionEnabled = true
        point4Button.isUserInteractionEnabled = true
        point5Button.isUserInteractionEnabled = true
        confirmSelection.isUserInteractionEnabled = true
        point8Button.isUserInteractionEnabled = true
        
        
        button1Recog.addTarget(self, action: #selector(TPAViewController.Blade12(_:)))
        button2Recog.addTarget(self, action: #selector(TPAViewController.Blade15(_:)))
        button3Recog.addTarget(self, action: #selector(TPAViewController.Blade18(_:)))
        button31Recog.addTarget(self, action: #selector(TPAViewController.Blade21(_:)))
        button4Recog.addTarget(self, action: #selector(TPAViewController.Blade24(_:)))
        button5Recog.addTarget(self, action: #selector(TPAViewController.Blade27(_:)))
        confirmRecog.addTarget(self, action: #selector(TPAViewController.Blade30(_:)))
        button8Recog.addTarget(self, action: #selector(TPAViewController.Blade33(_:)))
        
        point1Button.addGestureRecognizer(button1Recog)
        point2Button.addGestureRecognizer(button2Recog)
        point3Button.addGestureRecognizer(button3Recog)
        point31Button.addGestureRecognizer(button31Recog)
        point4Button.addGestureRecognizer(button4Recog)
        point5Button.addGestureRecognizer(button5Recog)
        confirmSelection.addGestureRecognizer(confirmRecog)
        point8Button.addGestureRecognizer(button8Recog)
        
        point1Button.backgroundColor = unselectedColor
        point2Button.backgroundColor = unselectedColor
        point3Button.backgroundColor = unselectedColor
        point4Button.backgroundColor = unselectedColor
        point5Button.backgroundColor = unselectedColor
        point31Button.backgroundColor = unselectedColor
        point8Button.backgroundColor = unselectedColor
        confirmSelection.backgroundColor = unselectedColor

        view.bringSubview(toFront: TPAButton)
        view.bringSubview(toFront: plusButton)
        view.bringSubview(toFront: menuView)
    }
    
    @IBAction func Blade12(_ sender: Any){
        procedure?.roundedRadius = 12
        drawSawbladeCircle()
        
        point1Button.backgroundColor = selectedColor
        point2Button.backgroundColor = unselectedColor
        point3Button.backgroundColor = unselectedColor
        point4Button.backgroundColor = unselectedColor
        point5Button.backgroundColor = unselectedColor
        point31Button.backgroundColor = unselectedColor
        point8Button.backgroundColor = unselectedColor
        confirmSelection.backgroundColor = unselectedColor
    }
    
    @IBAction func Blade15(_ sender: Any){
        procedure?.roundedRadius = 15
        drawSawbladeCircle()
        
        point1Button.backgroundColor = unselectedColor
        point2Button.backgroundColor = selectedColor
        point3Button.backgroundColor = unselectedColor
        point4Button.backgroundColor = unselectedColor
        point5Button.backgroundColor = unselectedColor
        point31Button.backgroundColor = unselectedColor
        point8Button.backgroundColor = unselectedColor
        confirmSelection.backgroundColor = unselectedColor
    }
    
    @IBAction func Blade18(_ sender: Any){
        procedure?.roundedRadius = 18
        drawSawbladeCircle()
        
        point1Button.backgroundColor = unselectedColor
        point2Button.backgroundColor = unselectedColor
        point3Button.backgroundColor = selectedColor
        point4Button.backgroundColor = unselectedColor
        point5Button.backgroundColor = unselectedColor
        point31Button.backgroundColor = unselectedColor
        point8Button.backgroundColor = unselectedColor
        confirmSelection.backgroundColor = unselectedColor
    }
    
    @IBAction func Blade21(_ sender: Any){
        procedure?.roundedRadius = 21
        drawSawbladeCircle()
        
        point1Button.backgroundColor = unselectedColor
        point2Button.backgroundColor = unselectedColor
        point3Button.backgroundColor = unselectedColor
        point4Button.backgroundColor = unselectedColor
        point5Button.backgroundColor = unselectedColor
        point31Button.backgroundColor = selectedColor
        point8Button.backgroundColor = unselectedColor
        confirmSelection.backgroundColor = unselectedColor
    }
    
    @IBAction func Blade24(_ sender: Any){
        procedure?.roundedRadius = 24
        drawSawbladeCircle()
        
        point1Button.backgroundColor = unselectedColor
        point2Button.backgroundColor = unselectedColor
        point3Button.backgroundColor = unselectedColor
        point4Button.backgroundColor = selectedColor
        point5Button.backgroundColor = unselectedColor
        point31Button.backgroundColor = unselectedColor
        point8Button.backgroundColor = unselectedColor
        confirmSelection.backgroundColor = unselectedColor
    }
    
    @IBAction func Blade27(_ sender: Any){
        procedure?.roundedRadius = 27
        drawSawbladeCircle()
        
        point1Button.backgroundColor = unselectedColor
        point2Button.backgroundColor = unselectedColor
        point3Button.backgroundColor = unselectedColor
        point4Button.backgroundColor = unselectedColor
        point5Button.backgroundColor = selectedColor
        point31Button.backgroundColor = unselectedColor
        point8Button.backgroundColor = unselectedColor
        confirmSelection.backgroundColor = unselectedColor
    }
    
    @IBAction func Blade30(_ sender: Any){
        procedure?.roundedRadius = 30
        drawSawbladeCircle()
        
        point1Button.backgroundColor = unselectedColor
        point2Button.backgroundColor = unselectedColor
        point3Button.backgroundColor = unselectedColor
        point4Button.backgroundColor = unselectedColor
        point5Button.backgroundColor = unselectedColor
        point31Button.backgroundColor = unselectedColor
        point8Button.backgroundColor = unselectedColor
        confirmSelection.backgroundColor = selectedColor
    }
    
    @IBAction func Blade33(_ sender: Any){
        procedure?.roundedRadius = 33
        drawSawbladeCircle()
        
        point1Button.backgroundColor = unselectedColor
        point2Button.backgroundColor = unselectedColor
        point3Button.backgroundColor = unselectedColor
        point4Button.backgroundColor = unselectedColor
        point5Button.backgroundColor = unselectedColor
        point31Button.backgroundColor = unselectedColor
        point8Button.backgroundColor = selectedColor
        confirmSelection.backgroundColor = unselectedColor
    }

    
    func drawSawbladeCircle(){
        circleLayer.removeFromSuperlayer()
        
        nextButton.isEnabled = true
        
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions((imageView.image?.size)!, opaque, scale)
        
        let sawbladeCircle = UIBezierPath()

        sawbladeCircle.addArc(withCenter: CGPoint(x: (procedure?.intersectionPoint.x)!, y: (procedure?.intersectionPoint.y)!), radius: CGFloat(Float(Double((procedure?.roundedRadius)!) * (procedure?.pixelToMMRatio)!)), startAngle: CGFloat(getNewAngle()) - (20 * CGFloat.pi / 180), endAngle: CGFloat(getNewAngle()) + (115 * CGFloat.pi / 180), clockwise: true)
        
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
        if(plusButton.image! == #imageLiteral(resourceName: "PlusButtonBlue") || plusBotConstraint.constant == 20.0){
            menuBotConstraint.constant = 0
            plusBotConstraint.constant += 300
            textBotConstraint.constant += 300
            tpaBotConstraint.constant += 300
            
            plusButton.image = #imageLiteral(resourceName: "DownButtonBlue")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            menuBotConstraint.constant = -300
            plusBotConstraint.constant -= 300
            textBotConstraint.constant -= 300
            tpaBotConstraint.constant -= 300
            
            plusButton.image = #imageLiteral(resourceName: "PlusButtonBlue")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
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
        
        //lines.move(to: (procedure?.intersectionPoint)!)
        //lines.addArc(withCenter: (procedure?.intersectionPoint)!, radius: 20, startAngle: CGFloat(getNewAngle()), endAngle: CGFloat(getOtherAngle()), clockwise: false)
        
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
        
        guard let nextController = segue.destination as? PlateSizeViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        procedure?.sawbladeRadius = Double((procedure?.roundedRadius!)!)
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
