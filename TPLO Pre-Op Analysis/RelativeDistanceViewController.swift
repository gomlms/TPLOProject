//
//  RelativeDistanceViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 1/22/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit
import os.log

class RelativeDistanceViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: Properties
    
    var procedure : Procedure?
    var points = [CGPoint]()
    var currSelector = 0
    
    var isTop = false
    var isBot = false
    
    var selectedColor : UIColor = UIColor(red:0.00, green:0.74, blue:0.89, alpha:0.7)
    var unselectedColor : UIColor = UIColor(red:0.00, green:0.32, blue:0.61, alpha:0.7)
    var greyColor : UIColor = UIColor(red:0.27, green:0.35, blue:0.34, alpha:1.0)
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var menuBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var zoomBotConstraint: NSLayoutConstraint!

    @IBOutlet weak var plusButton: UIImageView!
    @IBOutlet weak var menuView: UIImageView!
    
    var pointOneButton = UIView()
    var pointTwoButton = UIView()
    var confirmButton = UIView()
    
    var confirmSelectionButton = UIImageView(image: #imageLiteral(resourceName: "CheckButtonBlue"))
    @IBOutlet weak var zoomedView: UIImageView!
    
    var pointOneCreated = false
    var pointTwoCreated = false
    
    var radiographImage = #imageLiteral(resourceName: "defaultPhoto")

    var currHeight : CGFloat = 300

    var zoomedViewWidth: CGFloat = 200, zoomedViewHeight: CGFloat = 200
    
    let dotView = UIImageView(image: #imageLiteral(resourceName: "dot1"))
    
    var prevHeight : CGFloat = 1.0
    var firstHeight : Bool = true
    
    var imageView = UIImageView()
    var imageViewWidth = CGFloat(0)
    var imageViewHeight = CGFloat(0)
    
    var innerView = UIView()
    var scrollView = UIScrollView()
    
    var imageWidth = CGFloat(0)
    var imageHeight = CGFloat(0)
    var imageRatio = CGFloat(0)
    
    var currentImageViewPoint = CGPoint.zero
    
    var currentDot = #imageLiteral(resourceName: "dot1")
    var dot1ImageView = UIImageView(image: #imageLiteral(resourceName: "dot1"))
    var dot2ImageView = UIImageView(image: #imageLiteral(resourceName: "dot2"))
    
    var dot1Recog = UITapGestureRecognizer()
    var dot2Recog = UITapGestureRecognizer()
    var confirmRecog = UITapGestureRecognizer()
    
    @IBOutlet var zoomRecog: ZoomGestureRecognizer!
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "Continue" {
            guard let nextController = segue.destination as? SelectFirstFourPointsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let distance = Double(sqrt(pow(points[0].x - points[1].x, 2) + pow(points[0].y - points[1].y, 2)))
            
            if(procedure?.designator == "Marker"){
                procedure?.pixelToMMRatio = distance / 100.0
                
            } else {
                procedure?.pixelToMMRatio = distance / 25.0
            }
            
            nextController.procedure = procedure
        } else {
            guard let nextController = segue.destination as? FirstPropertiesViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            nextController.nameTextField.text = procedure?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        
        updateNextButtonState()
        
        points.append(CGPoint(x: 0.0, y: 0.0))
        points.append(CGPoint(x: 0.0, y: 0.0))
        
        pointOneButton.isUserInteractionEnabled = true
        pointTwoButton.isUserInteractionEnabled = true
        
        guard let procedure = procedure else{
            fatalError("Procedure was not correctly passed to Relative Distance Controller")
        }
        
        radiographImage = procedure.radiograph!
        
        imageViewWidth = procedure.imageViewWidth
        imageViewHeight = procedure.imageViewHeight
        
        imageWidth = (procedure.radiograph?.size.width)!
        imageHeight = (procedure.radiograph?.size.height)!
      
        /*
        if(imageViewHeight > maxAllowedHeight()) {
            imageViewHeight = maxAllowedHeight()
            imageViewWidth = imageViewHeight * imageRatio
        } else {
            scrollView.frame = CGRect(x: 20, y: calcYPos(), width: imageViewWidth, height: imageViewHeight)
        }*/
        
        scrollView.frame = CGRect(x: procedure.imageViewXOrigin, y: 0, width: imageViewWidth, height: imageViewHeight)
        
        scrollView.contentSize = CGSize(width: imageViewWidth, height: imageViewHeight)
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        scrollView.layer.zPosition = -10
        
        innerView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        scrollView.addSubview(innerView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        imageView.addGestureRecognizer(zoomRecog)
        imageView.isUserInteractionEnabled = false
        imageView.image = radiographImage
        innerView.addSubview(imageView)
        
        dotView.image = currentDot
        dotView.frame = CGRect(x: zoomedViewWidth / 2  - 5, y: zoomedViewHeight / 2 - 5, width: 10, height: 10)
        
        zoomedViewWidth = zoomedView.frame.width
        zoomedViewHeight = zoomedView.frame.height
        
        zoomedView.addSubview(dotView)
        zoomedView.isHidden = true
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        self.view.addSubview(scrollView)
        self.view.bringSubview(toFront: plusButton)
        
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = screenWidth / 3.0
        let dotRadius = buttonWidth / 3
        let dotPosX = buttonWidth / 3
        let dotPosY = menuView.frame.height / 6
        
        pointOneButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: menuView.frame.height)
        
        let dot1Image = UIImageView(image: #imageLiteral(resourceName: "dot1"))
        dot1Image.frame = CGRect(x: dotPosX, y: dotPosY, width: dotRadius, height: dotRadius)
        dot1Image.contentMode = UIViewContentMode.scaleAspectFit
        
        let dot1Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 6.0 + dotRadius + menuView.frame.height / 12, width: buttonWidth * 4 / 5, height: 60))
        dot1Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot1Label.numberOfLines = 0
        dot1Label.font = UIFont(name:"Open Sans", size: 20)
        dot1Label.textColor = UIColor.white
        dot1Label.textAlignment = .center
        dot1Label.text = "Relative\nPoint 1"
        
        pointOneButton.layer.borderColor = UIColor.gray.cgColor
        pointOneButton.layer.borderWidth = 2.0
        pointOneButton.layer.shadowRadius = 10.0
        
        pointOneButton.addSubview(dot1Image)
        pointOneButton.addSubview(dot1Label)
        
        menuView.addSubview(pointOneButton)
        
        pointTwoButton.frame = CGRect(x: buttonWidth, y: 0, width: buttonWidth, height: menuView.frame.height)
        
        let dot2Image = UIImageView(image: #imageLiteral(resourceName: "dot2"))
        dot2Image.frame = CGRect(x: dotPosX, y: dotPosY, width: dotRadius, height: dotRadius)
        dot2Image.contentMode = UIViewContentMode.scaleAspectFit
        
        let dot2Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 6.0 + dotRadius + menuView.frame.height / 12, width: buttonWidth * 4 / 5, height: 60))
        dot2Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot2Label.numberOfLines = 0
        dot2Label.font = UIFont(name:"Open Sans", size: 20)
        dot2Label.textColor = UIColor.white
        dot2Label.textAlignment = .center
        dot2Label.text = "Relative\nPoint 2"
    
        pointTwoButton.layer.borderColor = UIColor.gray.cgColor
        pointTwoButton.layer.borderWidth = 2.0
        pointTwoButton.layer.shadowRadius = 10.0
        
        pointTwoButton.addSubview(dot2Image)
        pointTwoButton.addSubview(dot2Label)
        
                menuView.addSubview(pointTwoButton)
        
        confirmButton.frame = CGRect(x: buttonWidth * 2, y: 0, width: buttonWidth, height: menuView.frame.height)
        
        let confirmLabel = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 6.0 + dotRadius + menuView.frame.height / 12, width: buttonWidth * 4 / 5, height: 60))
        confirmLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        confirmLabel.numberOfLines = 0
        confirmLabel.font = UIFont(name:"Open Sans", size: 20)
        confirmLabel.textColor = UIColor.white
        confirmLabel.textAlignment = .center
        confirmLabel.text = "Confirm\nSelection"
        
        confirmButton.layer.borderColor = UIColor.gray.cgColor
        confirmButton.layer.borderWidth = 2.0
        confirmButton.layer.shadowRadius = 10.0
        
        let confirmButtonImage = UIImageView(image: #imageLiteral(resourceName: "ConfirmButtonBlue"))
        confirmButtonImage.frame = CGRect(x: dotPosX, y: dotPosY, width: dotRadius, height: dotRadius)
        confirmButtonImage.contentMode = UIViewContentMode.scaleAspectFit
        
        confirmButton.addSubview(confirmButtonImage)
        confirmButton.addSubview(confirmLabel)
        
        menuView.addSubview(confirmButton)
        
        pointOneButton.isUserInteractionEnabled = true
        pointTwoButton.isUserInteractionEnabled = true
        menuView.isUserInteractionEnabled = true
        confirmButton.isUserInteractionEnabled = false
        
        dot1Recog.addTarget(self, action: #selector(RelativeDistanceViewController.selectPointOne(_:)))
        dot2Recog.addTarget(self, action: #selector(RelativeDistanceViewController.selectPointTwo(_:)))
        confirmRecog.addTarget(self, action: #selector(RelativeDistanceViewController.confirmSelectedAction(_:)))
        
        pointOneButton.addGestureRecognizer(dot1Recog)
        pointTwoButton.addGestureRecognizer(dot2Recog)
        confirmButton.addGestureRecognizer(confirmRecog)
        
        self.view.bringSubview(toFront: menuView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action

    
    //MARK: SelectionButtonsActions
    
    @IBAction func selectPointOne(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot1")
        dotView.image = #imageLiteral(resourceName: "dot1")
        currSelector = 1
        
        pointOneButton.backgroundColor = selectedColor
        pointTwoButton.backgroundColor = greyColor
        confirmButton.backgroundColor = unselectedColor
        
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func selectPointTwo(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot2")
        dotView.image = #imageLiteral(resourceName: "dot2")
        currSelector = 2
        
        pointOneButton.backgroundColor = greyColor
        pointTwoButton.backgroundColor = selectedColor
        confirmButton.backgroundColor = unselectedColor
        
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func confirmSelectedAction(_ sender: Any) {
        imageView.isUserInteractionEnabled = false
        enableSelectionButtons()
        zoomedView.isHidden = true
        
        confirmButton.backgroundColor = selectedColor
        pointOneButton.backgroundColor = unselectedColor
        pointTwoButton.backgroundColor = unselectedColor
        
        points[currSelector - 1] = currentImageViewPoint
        updateNextButtonState()
        
        confirmButton.isUserInteractionEnabled = false
    }
    
    //MARK: Private Methods
    
     
    private func updateNextButtonState() {
        if pointOneCreated && pointTwoCreated {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    private func disableSelectionButtons() {

    }
    
    private func enableSelectionButtons() {

    }
    
    @IBAction func tapDown(sender: ZoomGestureRecognizer) {
        zoomedView.isHidden = false
        let point = sender.location(in: imageView)
        zoomedView.image = getZoomedImage(point: point)
        
        if(point.y < self.imageViewHeight / 2){
            isTop = true
            if(plusButton.image != #imageLiteral(resourceName: "DownButtonBlue")){
                zoomBotConstraint.constant = imageViewHeight * 0.1
            }
        } else {
            isBot = true
            zoomBotConstraint.constant = imageViewHeight * 0.6
        }
        
        zoomedView.layer.borderColor = UIColor(red:0.00, green:0.74, blue:0.89, alpha:1.0).cgColor
        zoomedView.layer.shadowRadius = 14
        zoomedView.layer.shadowColor = UIColor.white.cgColor
        zoomedView.layer.borderWidth = 1.0
        
        if(plusButton.image == #imageLiteral(resourceName: "DownButtonBlue")){
            animate(self)
        }
        
        if(isTop && isBot) {
            zoomedView.alpha = 0
            if(plusButton.image != #imageLiteral(resourceName: "DownButtonBlue")){
                UIView.animate(withDuration: 0.5, animations: {
                    self.zoomedView.alpha = 1.0
                })
            }
        
            if(point.y < self.imageViewHeight / 2){
                isBot = false
            } else {
                isTop = false
            }
        }
        
        if(currentDot == #imageLiteral(resourceName: "dot1")) {
            createDotAt(dotImageView: dot1ImageView, coordInImageView: currentImageViewPoint)
        } else if(currentDot == #imageLiteral(resourceName: "dot2")) {
            createDotAt(dotImageView: dot2ImageView, coordInImageView: currentImageViewPoint)
        }
        if(sender.state == .ended) {
            
            if(currentDot == #imageLiteral(resourceName: "dot1")) {
                createDotAt(dotImageView: dot1ImageView, coordInImageView: currentImageViewPoint)
                pointOneCreated = true
            } else if(currentDot == #imageLiteral(resourceName: "dot2")){
                createDotAt(dotImageView: dot2ImageView, coordInImageView: currentImageViewPoint)
                pointTwoCreated = true
            }
            
            confirmButton.isUserInteractionEnabled = true
        }
        
    }
    
    
    @IBAction func animate(_ sender: Any) {
        if(plusButton.image == #imageLiteral(resourceName: "PlusButtonBlue")){
            menuBotConstraint.constant = 0
            plusBotConstraint.constant += 200
            
            if(isTop){
                zoomBotConstraint.constant += 200
            }
        
            plusButton.image = #imageLiteral(resourceName: "DownButtonBlue")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            menuBotConstraint.constant = -200
            plusBotConstraint.constant -= 200
            
            if(isTop){
                zoomBotConstraint.constant -= 200
            }
            
            plusButton.image = #imageLiteral(resourceName: "PlusButtonBlue")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func getZoomedImage(point: CGPoint) -> UIImage {
        let width: CGFloat = 100.0, height: CGFloat = 100.0
        let cgImage = imageView.image?.cgImage
        
        var croppedCgImage: CGImage?
        var convertedPoint = CGPoint.zero
        
        currentImageViewPoint = point
        
        convertedPoint.x = (point.x * CGFloat((cgImage?.width)!)) / imageViewWidth
        convertedPoint.y = (point.y * CGFloat((cgImage?.height)!)) / imageViewHeight
        
        if(convertedPoint.x >= (width / 2) && convertedPoint.x <= imageWidth - (width / 2) && convertedPoint.y >= (height / 2) && convertedPoint.y <= imageHeight - (height / 2)) {
            dotView.frame.origin = CGPoint(x: zoomedViewWidth / 2  - 5, y: zoomedViewHeight / 2 - 5)
            let croppingRect = CGRect(x: convertedPoint.x - (width / 2.0), y: convertedPoint.y - (height / 2.0), width: width, height: height)
            croppedCgImage = cgImage?.cropping(to: croppingRect)
        } else {
            var newPoint = convertedPoint
            
            if(convertedPoint.x <= (width / 2)) {
                if(convertedPoint.x < 0) {
                    convertedPoint.x = 0
                    currentImageViewPoint.x = 0
                }
                newPoint.x = (width / 2)
                dotView.frame.origin.x = (zoomedViewWidth / width) * (convertedPoint.x) - 5
            } else if(convertedPoint.x >= imageWidth - (width / 2)) {
                if(convertedPoint.x > imageWidth) {
                    convertedPoint.x = imageWidth
                    currentImageViewPoint.x = imageViewWidth
                }
                newPoint.x = imageWidth - (width / 2)
                dotView.frame.origin.x = (zoomedViewWidth / width) * (convertedPoint.x - (imageWidth - width)) - 5
            }
            
            if(convertedPoint.y <= (height / 2)) {
                if(convertedPoint.y < 0) {
                    convertedPoint.y = 0
                    currentImageViewPoint.y = 0
                }
                newPoint.y = (height / 2)
                dotView.frame.origin.y = (zoomedViewHeight / height) * (convertedPoint.y) - 5
            } else if(convertedPoint.y >= imageHeight - (height / 2)) {
                if(convertedPoint.y > imageHeight) {
                    convertedPoint.y = imageHeight
                    currentImageViewPoint.y = imageViewHeight
                }
                newPoint.y = imageHeight - (height / 2)
                dotView.frame.origin.y = (zoomedViewHeight / height) * (convertedPoint.y - (imageHeight - height)) - 5
            }
            
            let croppingRect = CGRect(x: newPoint.x - (width / 2), y: newPoint.y - (height / 2), width: width, height: height)
            croppedCgImage = cgImage?.cropping(to: croppingRect)
        }
        
        return UIImage(cgImage: croppedCgImage!)
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
    
    private func createDotAt(dotImageView: UIImageView, coordInImageView: CGPoint) {
        dotImageView.frame = CGRect(x: coordInImageView.x - 5, y: coordInImageView.y - 5, width: 10, height: 10)
        innerView.addSubview(dotImageView)
    }
    
    private func removeDot(dotImageView: UIImageView) {
        dotImageView.removeFromSuperview()
    }
}
