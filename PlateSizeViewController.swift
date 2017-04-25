//
//  PlateSizeViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 2/24/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class PlateSizeViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    var rotatingView = UIView()
    var radiographView = UIImageView()
    var backgroundView = UIImageView()
    var innerView = UIView()
    var scrollView = UIScrollView()
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
    
    var movingImage = UIImageView()

    var broadButton = UIView()
    var shortButton = UIView()
    var standardButton = UIView()
    var confirmSelection = UIView()
    var deleteButton = UIView()
    
    var broadRecog = UITapGestureRecognizer()
    var shortRecog = UITapGestureRecognizer()
    var standardRecog = UITapGestureRecognizer()
    var confirmRecog = UITapGestureRecognizer()
    var deleteRecog = UITapGestureRecognizer()
    
    @IBOutlet weak var menuView: UIImageView!
    @IBOutlet weak var plusBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusButton: UIImageView!
    
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
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        
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
        
        view.bringSubview(toFront: menuView)
        view.bringSubview(toFront: plusButton)
        
        // Do any additional setup after loading the view.
        
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = screenWidth / 3.0
        let buttonHeight = menuView.frame.height / 2
        let plateWidth = buttonWidth * (3/5)
        let platePosX = buttonWidth / 5
        let platePosY = buttonHeight / 12
        
        standardButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        
        let standardImage = UIImageView(image: #imageLiteral(resourceName: "standard3.5(65mm)"))
        standardImage.frame = CGRect(x: platePosX, y: platePosY, width: plateWidth, height: plateWidth)
        standardImage.contentMode = UIViewContentMode.scaleAspectFit
        
        let standardLabel = UILabel(frame: CGRect(x: buttonWidth / 10, y: platePosY + plateWidth - buttonWidth / 48, width: buttonWidth * 4 / 5, height: 60))
        standardLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        standardLabel.numberOfLines = 0
        standardLabel.font = UIFont(name:"Open Sans", size: 20)
        standardLabel.textColor = UIColor.white
        standardLabel.textAlignment = .center
        standardLabel.text = "Standard\n3.5"
        
        standardButton.layer.borderColor = UIColor.gray.cgColor
        standardButton.layer.borderWidth = 2.0
        standardButton.layer.shadowRadius = 10.0
        
        standardButton.addSubview(standardImage)
        standardButton.addSubview(standardLabel)
        
        standardButton.isUserInteractionEnabled = true
        menuView.addSubview(standardButton)
     
        broadButton.frame = CGRect(x: buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        
        let broadImage = UIImageView(image: #imageLiteral(resourceName: "broad3.5(79mm)"))
        broadImage.frame = CGRect(x: platePosX, y: platePosY, width: plateWidth, height: plateWidth)
        broadImage.contentMode = UIViewContentMode.scaleAspectFit
        
        let broadLabel = UILabel(frame: CGRect(x: buttonWidth / 10, y: platePosY + plateWidth - buttonWidth / 48, width: buttonWidth * 4 / 5, height: 60))
        broadLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        broadLabel.numberOfLines = 0
        broadLabel.font = UIFont(name:"Open Sans", size: 20)
        broadLabel.textColor = UIColor.white
        broadLabel.textAlignment = .center
        broadLabel.text = "Broad\n3.5"
        
        broadButton.layer.borderColor = UIColor.gray.cgColor
        broadButton.layer.borderWidth = 2.0
        broadButton.layer.shadowRadius = 10.0
        
        broadButton.addSubview(broadImage)
        broadButton.addSubview(broadLabel)
        
        broadButton.isUserInteractionEnabled = true
        menuView.addSubview(broadButton)
        
        shortButton.frame = CGRect(x: 2 * buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        
        let shortImage = UIImageView(image: #imageLiteral(resourceName: "short3.5(56mm)"))
        shortImage.frame = CGRect(x: platePosX, y: platePosY, width: plateWidth, height: plateWidth)
        shortImage.contentMode = UIViewContentMode.scaleAspectFit
        
        let shortLabel = UILabel(frame: CGRect(x: buttonWidth / 10, y: platePosY + plateWidth - buttonWidth / 48, width: buttonWidth * 4 / 5, height: 60))
        shortLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        shortLabel.numberOfLines = 0
        shortLabel.font = UIFont(name:"Open Sans", size: 20)
        shortLabel.textColor = UIColor.white
        shortLabel.textAlignment = .center
        shortLabel.text = "Short\n3.5"
        
        shortButton.layer.borderColor = UIColor.gray.cgColor
        shortButton.layer.borderWidth = 2.0
        shortButton.layer.shadowRadius = 10.0
        
        shortButton.addSubview(shortImage)
        shortButton.addSubview(shortLabel)
        
        shortButton.isUserInteractionEnabled = true
        menuView.addSubview(shortButton)
        
        deleteButton.frame = CGRect(x: 0, y: buttonHeight, width: buttonWidth, height: buttonHeight)
        
        let deleteImage = UIImageView(image: #imageLiteral(resourceName: "RemoveButton"))
        deleteImage.frame = CGRect(x: platePosX, y: platePosY, width: plateWidth, height: plateWidth)
        deleteImage.contentMode = UIViewContentMode.scaleAspectFit
        
        let deleteLabel = UILabel(frame: CGRect(x: buttonWidth / 10, y: platePosY + plateWidth - buttonWidth / 48, width: buttonWidth * 4 / 5, height: 60))
        deleteLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        deleteLabel.numberOfLines = 0
        deleteLabel.font = UIFont(name:"Open Sans", size: 20)
        deleteLabel.textColor = UIColor.white
        deleteLabel.textAlignment = .center
        deleteLabel.text = "Remove Plate"
        
        deleteButton.layer.borderColor = UIColor.gray.cgColor
        deleteButton.layer.borderWidth = 2.0
        deleteButton.layer.shadowRadius = 10.0
        
        deleteButton.addSubview(deleteImage)
        deleteButton.addSubview(deleteLabel)
        
        deleteButton.isUserInteractionEnabled = true
        menuView.addSubview(deleteButton)
        
        confirmSelection.frame = CGRect(x: 2 * buttonWidth, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let confirmImage = UIImageView(image: #imageLiteral(resourceName: "CheckButtonBlue"))
        confirmImage.frame = CGRect(x: platePosX, y: platePosY, width: plateWidth, height: plateWidth)
        confirmImage.contentMode = UIViewContentMode.scaleAspectFit
        
        let confirmLabel = UILabel(frame: CGRect(x: buttonWidth / 10, y: platePosY + plateWidth - menuView.frame.height / 48, width: buttonWidth * 4 / 5, height: 60))
        confirmLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        confirmLabel.numberOfLines = 0
        confirmLabel.font = UIFont(name:"Open Sans", size: 20)
        confirmLabel.textColor = UIColor.white
        confirmLabel.textAlignment = .center
        confirmLabel.text = "Confirm"
        
        confirmSelection.layer.borderColor = UIColor.gray.cgColor
        confirmSelection.layer.borderWidth = 2.0
        confirmSelection.layer.shadowRadius = 10.0
        
        confirmSelection.addSubview(confirmImage)
        confirmSelection.addSubview(confirmLabel)
        
        confirmSelection.isUserInteractionEnabled = true
        menuView.addSubview(confirmSelection)
    
        
        standardRecog.addTarget(self, action: #selector(PlateSizeViewController.standardPress(_:)))
        broadRecog.addTarget(self, action: #selector(PlateSizeViewController.broadPress(_:)))
        shortRecog.addTarget(self, action: #selector(PlateSizeViewController.shortPress(_:)))
        confirmRecog.addTarget(self, action: #selector(PlateSizeViewController.confirmPress(_:)))
        deleteRecog.addTarget(self, action: #selector(PlateSizeViewController.deletePress(_:)))
        
        standardButton.addGestureRecognizer(standardRecog)
        broadButton.addGestureRecognizer(broadRecog)
        shortButton.addGestureRecognizer(shortRecog)
        confirmSelection.addGestureRecognizer(confirmRecog)
        deleteButton.addGestureRecognizer(deleteRecog)
        
        menuView.isUserInteractionEnabled = true
        
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
    
    @IBAction func standardPress(_ sender: Any) {
        movingImage.image = #imageLiteral(resourceName: "standard3.5(65mm)")
        if(imageInSuperview){
            handleTap()
        }
        handleTap()
    }
    
    @IBAction func broadPress(_ sender: Any) {
        movingImage.image = #imageLiteral(resourceName: "broad3.5(79mm)")
        if(imageInSuperview){
            handleTap()
        }
        handleTap()
    }
    
    @IBAction func shortPress(_ sender: Any) {
        movingImage.image = #imageLiteral(resourceName: "short3.5(56mm)")
        if(imageInSuperview){
            handleTap()
        }
        handleTap()
    }
    
    @IBAction func confirmPress(_ sender: Any) {
        if(imageInSuperview){
            pressPlus(self)
            self.view.removeGestureRecognizer(movingRecognizer)
            self.view.removeGestureRecognizer(rotatingRecognizer)
        }
    }
    
    @IBAction func deletePress(_ sender: Any) {
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
        
        originOfActiveImage = CGPoint.zero
        activeImage = nil
        imageInSuperview = false
        totalRotation = 0.0
    }
    
    func handleTap() {
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
                
                let screenWidth = UIScreen.main.bounds.width
                
                let plateWidth: CGFloat = CGFloat(desiredWidth * (procedure?.pixelToMMRatio)!)
                let plateHeight: CGFloat = CGFloat(desiredHeight * (procedure?.pixelToMMRatio)!)
                
                movingImage.removeFromSuperview()
                movingImage.frame = CGRect(x: (screenWidth - plateWidth) / 2.0, y: 100.0, width: plateWidth, height: plateHeight)
                self.view.addSubview(movingImage)
                view.bringSubview(toFront: menuView)
                
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
                    
                    originOfActiveImage = CGPoint.zero
                    activeImage = nil
                    imageInSuperview = false
                    totalRotation = 0.0
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return innerView
    }
    
    
    @IBAction func pressPlus(_ sender: Any) {
        if(plusButton.image == #imageLiteral(resourceName: "PlusButtonBlue")){
            menuBotConstraint.constant = 0
            plusBotConstraint.constant += 300
            
            plusButton.image = #imageLiteral(resourceName: "DownButtonBlue")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            menuBotConstraint.constant = -300
            plusBotConstraint.constant -= 300
            
            plusButton.image = #imageLiteral(resourceName: "PlusButtonBlue")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
