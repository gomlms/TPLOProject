//
//  SelectFirstFourPointsViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Erik Melone on 1/31/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class SelectFirstFourPointsViewController: UIViewController, UIScrollViewDelegate{

    //MARK: Properties
    
    var procedure : Procedure?
    var currentPoint = CGPoint(x: 0.0, y: 0.0)
    var points = [CGPoint]()
    var currSelector = 0
    
    var isTop = false
    var isBot = false
    
    var point1Button = UIView()
    var point2Button = UIView()
    var point3Button = UIView()
    var point4Button = UIView()
    var point5Button = UIView()
    var confirmSelection = UIView()
    
    @IBOutlet weak var zoomedView: UIImageView!
    @IBOutlet var zoomRecog: ZoomGestureRecognizer!
    
    var radiographImage = #imageLiteral(resourceName: "defaultPhoto")
    
    var currentPoints = [CGPoint]()
    var currHeight : CGFloat = 300
    
    var zoomedViewWidth: CGFloat = 200, zoomedViewHeight: CGFloat = 200
    
    let dotView = UIImageView(image: #imageLiteral(resourceName: "dot1"))
    
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
    var dot3ImageView = UIImageView(image: #imageLiteral(resourceName: "dot3"))
    var dot4ImageView = UIImageView(image: #imageLiteral(resourceName: "dot4"))
    var dot5ImageView = UIImageView(image: #imageLiteral(resourceName: "dot5"))
    
    var p1Chose = false
    var p2Chose = false
    var p3Chose = false
    var p4Chose = false
    var p5Chose = false
    
    @IBOutlet weak var menuBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var zoomBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusBotConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuView: UIImageView!
    @IBOutlet weak var plusButton: UIImageView!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var button1Recog = UITapGestureRecognizer()
    var button2Recog = UITapGestureRecognizer()
    var button3Recog = UITapGestureRecognizer()
    var button4Recog = UITapGestureRecognizer()
    var button5Recog = UITapGestureRecognizer()
    var confirmRecog = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        
        nextButton.isEnabled = false
        
        plusButton.isUserInteractionEnabled = true
        
        points.append(CGPoint(x: 0.0, y: 0.0))
        points.append(CGPoint(x: 0.0, y: 0.0))
        points.append(CGPoint(x: 0.0, y: 0.0))
        points.append(CGPoint(x: 0.0, y: 0.0))
        points.append(CGPoint(x: 0.0, y: 0.0))
        
        currentPoints.append(CGPoint(x: 0.0, y: 0.0))
        currentPoints.append(CGPoint(x: 0.0, y: 0.0))
        currentPoints.append(CGPoint(x: 0.0, y: 0.0))
        currentPoints.append(CGPoint(x: 0.0, y: 0.0))
        currentPoints.append(CGPoint(x: 0.0, y: 0.0))
        
        confirmSelection.isUserInteractionEnabled = false
        
        guard let procedure = procedure else {
            fatalError("Procedure was not correctly passed to Relative Distance Controller")
        }
        
        radiographImage = procedure.radiograph!
        
        imageWidth = CGFloat((radiographImage.cgImage?.width)!)
        imageHeight = CGFloat((radiographImage.cgImage?.height)!)
        imageRatio = imageWidth / imageHeight
        
        /*imageViewWidth = screenWidth - 40
        imageViewHeight = imageViewWidth / imageRatio*/
        
        imageViewWidth = procedure.imageViewWidth
        imageViewHeight = procedure.imageViewHeight
        
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

        self.view.addSubview(scrollView)
        
        dotView.image = currentDot
        dotView.frame = CGRect(x: zoomedViewWidth / 2  - 5, y: zoomedViewHeight / 2 - 5, width: 10, height: 10)
        
        zoomedViewWidth = zoomedView.frame.width
        zoomedViewHeight = zoomedView.frame.height
        
        zoomedView.addSubview(dotView)
        zoomedView.isHidden = true
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        self.view.sendSubview(toBack: scrollView)
        
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = screenWidth / 3.0
        let dotRadius = buttonWidth / 3
        let dotPosX = buttonWidth / 3
        let dotPosY = menuView.frame.height / 12.0
        
        point1Button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot1Image = UIImageView(image: #imageLiteral(resourceName: "dot1"))
        dot1Image.frame = CGRect(x: dotPosX, y: dotPosY, width: dotRadius, height: dotRadius)
        dot1Image.contentMode = UIViewContentMode.scaleAspectFit
        
        let dot1Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: dotPosY + dotRadius + menuView.frame.height / 24, width: buttonWidth * 4 / 5, height: 60))
        dot1Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot1Label.numberOfLines = 0
        dot1Label.font = UIFont(name:"Open Sans", size: 20)
        dot1Label.textColor = UIColor.white
        dot1Label.textAlignment = .center
        dot1Label.text = "Midpoint\nTibial Eminence"
        
        point1Button.layer.borderColor = UIColor.gray.cgColor
        point1Button.layer.borderWidth = 2.0
        point1Button.layer.shadowRadius = 10.0
        
        point1Button.addSubview(dot1Image)
        point1Button.addSubview(dot1Label)
        
        menuView.addSubview(point1Button)
        
        point2Button.frame = CGRect(x: buttonWidth, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot2Image = UIImageView(image: #imageLiteral(resourceName: "dot2"))
        dot2Image.frame = CGRect(x: dotPosX, y: dotPosY, width: dotRadius, height: dotRadius)
        dot2Image.contentMode = UIViewContentMode.scaleAspectFit
        
        let dot2Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: dotPosY + dotRadius + menuView.frame.height / 24, width: buttonWidth * 4 / 5, height: 60))
        dot2Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot2Label.numberOfLines = 0
        dot2Label.font = UIFont(name:"Open Sans", size: 20)
        dot2Label.textColor = UIColor.white
        dot2Label.textAlignment = .center
        dot2Label.text = "Center\nOf Talus"
        
        point2Button.layer.borderColor = UIColor.gray.cgColor
        point2Button.layer.borderWidth = 2.0
        point2Button.layer.shadowRadius = 10.0
        
        point2Button.addSubview(dot2Image)
        point2Button.addSubview(dot2Label)
        
        menuView.addSubview(point2Button)
        
        point3Button.frame = CGRect(x: 2 * buttonWidth, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot3Image = UIImageView(image: #imageLiteral(resourceName: "dot3"))
        dot3Image.frame = CGRect(x: dotPosX, y: dotPosY, width: dotRadius, height: dotRadius)
        dot3Image.contentMode = UIViewContentMode.scaleAspectFit
        
        let dot3Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: dotPosY + dotRadius + menuView.frame.height / 24, width: buttonWidth * 4 / 5, height: 60))
        dot3Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot3Label.numberOfLines = 0
        dot3Label.font = UIFont(name:"Open Sans", size: 20)
        dot3Label.textColor = UIColor.white
        dot3Label.textAlignment = .center
        dot3Label.text = "Tibial Plateau\nPoint Cranial"
    
        point3Button.layer.borderColor = UIColor.gray.cgColor
        point3Button.layer.borderWidth = 2.0
        point3Button.layer.shadowRadius = 10.0
        
        point3Button.addSubview(dot3Image)
        point3Button.addSubview(dot3Label)
        
        menuView.addSubview(point3Button)
        
        point4Button.frame = CGRect(x: 0, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot4Image = UIImageView(image: #imageLiteral(resourceName: "dot4"))
        dot4Image.frame = CGRect(x: dotPosX, y: dotPosY, width: dotRadius, height: dotRadius)
        dot4Image.contentMode = UIViewContentMode.scaleAspectFit
        
        let dot4Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: dotPosY + dotRadius + menuView.frame.height / 24, width: buttonWidth * 4 / 5, height: 60))
        dot4Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot4Label.numberOfLines = 0
        dot4Label.font = UIFont(name:"Open Sans", size: 20)
        dot4Label.textColor = UIColor.white
        dot4Label.textAlignment = .center
        dot4Label.text = "Caudal"
        
        point4Button.layer.borderColor = UIColor.gray.cgColor
        point4Button.layer.borderWidth = 2.0
        point4Button.layer.shadowRadius = 10.0
        
        point4Button.addSubview(dot4Image)
        point4Button.addSubview(dot4Label)
        
        menuView.addSubview(point4Button)

        point5Button.frame = CGRect(x: buttonWidth, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot5Image = UIImageView(image: #imageLiteral(resourceName: "dot5"))
        dot5Image.frame = CGRect(x: dotPosX, y: dotPosY, width: dotRadius, height: dotRadius)
        dot5Image.contentMode = UIViewContentMode.scaleAspectFit
        
        let dot5Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: dotPosY + dotRadius + menuView.frame.height / 24, width: buttonWidth * 4 / 5, height: 60))
        dot5Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot5Label.numberOfLines = 0
        dot5Label.font = UIFont(name:"Open Sans", size: 20)
        dot5Label.textColor = UIColor.white
        dot5Label.textAlignment = .center
        dot5Label.text = "Proximal\nTubercle"
        
        point5Button.layer.borderColor = UIColor.gray.cgColor
        point5Button.layer.borderWidth = 2.0
        point5Button.layer.shadowRadius = 10.0
    
        point5Button.addSubview(dot5Image)
        point5Button.addSubview(dot5Label)
        
        menuView.addSubview(point5Button)
        
        confirmSelection.frame = CGRect(x: 2 * buttonWidth, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let confirmImage = UIImageView(image: #imageLiteral(resourceName: "CheckButtonBlue"))
        confirmImage.frame = CGRect(x: dotPosX, y: dotPosY, width: dotRadius, height: dotRadius)
        confirmImage.contentMode = UIViewContentMode.scaleAspectFit
        
        let confirmLabel = UILabel(frame: CGRect(x: buttonWidth / 10, y: dotPosY + dotRadius + menuView.frame.height / 24, width: buttonWidth * 4 / 5, height: 60))
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
        
        menuView.addSubview(confirmSelection)
        
        menuView.isUserInteractionEnabled = true
        point1Button.isUserInteractionEnabled = true
        point2Button.isUserInteractionEnabled = true
        point3Button.isUserInteractionEnabled = true
        point4Button.isUserInteractionEnabled = true
        point5Button.isUserInteractionEnabled = true
        confirmSelection.isUserInteractionEnabled = false
        
        
        button1Recog.addTarget(self, action: #selector(SelectFirstFourPointsViewController.selectPoint1(_:)))
        button2Recog.addTarget(self, action: #selector(SelectFirstFourPointsViewController.selectPoint2(_:)))
        button3Recog.addTarget(self, action: #selector(SelectFirstFourPointsViewController.selectPoint3(_:)))
        button4Recog.addTarget(self, action: #selector(SelectFirstFourPointsViewController.selectPoint4(_:)))
        button5Recog.addTarget(self, action: #selector(SelectFirstFourPointsViewController.selectPoint5(_:)))
        confirmRecog.addTarget(self, action: #selector(SelectFirstFourPointsViewController.confirmSelectionAction(_:)))
        
        point1Button.addGestureRecognizer(button1Recog)
        point2Button.addGestureRecognizer(button2Recog)
        point3Button.addGestureRecognizer(button3Recog)
        point4Button.addGestureRecognizer(button4Recog)
        point5Button.addGestureRecognizer(button5Recog)
        confirmSelection.addGestureRecognizer(confirmRecog)
        
        self.view.bringSubview(toFront: zoomedView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action
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
        } else if(currentDot == #imageLiteral(resourceName: "dot3")) {
            createDotAt(dotImageView: dot3ImageView, coordInImageView: currentImageViewPoint)
        } else if(currentDot == #imageLiteral(resourceName: "dot4")) {
            createDotAt(dotImageView: dot4ImageView, coordInImageView: currentImageViewPoint)
        } else if(currentDot == #imageLiteral(resourceName: "dot5")) {
            createDotAt(dotImageView: dot5ImageView, coordInImageView: currentImageViewPoint)
        }
        
        if(sender.state == .ended) {

            if(currentDot == #imageLiteral(resourceName: "dot1")) {
                createDotAt(dotImageView: dot1ImageView, coordInImageView: currentImageViewPoint)
                p1Chose = true
            } else if(currentDot == #imageLiteral(resourceName: "dot2")){
                createDotAt(dotImageView: dot2ImageView, coordInImageView: currentImageViewPoint)
                p2Chose = true
            } else if(currentDot == #imageLiteral(resourceName: "dot3")) {
                createDotAt(dotImageView: dot3ImageView, coordInImageView: currentImageViewPoint)
                p3Chose = true
            } else if(currentDot == #imageLiteral(resourceName: "dot4")) {
                createDotAt(dotImageView: dot4ImageView, coordInImageView: currentImageViewPoint)
                p4Chose = true
            } else if(currentDot == #imageLiteral(resourceName: "dot5")) {
                createDotAt(dotImageView: dot5ImageView, coordInImageView: currentImageViewPoint)
                p5Chose = true
            }
            
            confirmSelection.isUserInteractionEnabled = true
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
    
    private func createDotAt(dotImageView: UIImageView, coordInImageView: CGPoint) {
        dotImageView.frame = CGRect(x: coordInImageView.x - 5, y: coordInImageView.y - 5, width: 10, height: 10)
        imageView.addSubview(dotImageView)
    }
    
    private func removeDot(dotImageView: UIImageView) {
        dotImageView.removeFromSuperview()
    }
    
    //MARK: SelectionButtonsActions
    
    @IBAction func selectPoint1(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot1")
        dotView.image = #imageLiteral(resourceName: "dot1")
        currSelector = 1
        
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func selectPoint2(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot2")
        dotView.image = #imageLiteral(resourceName: "dot2")
        currSelector = 2
        
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func selectPoint3(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot3")
        dotView.image = #imageLiteral(resourceName: "dot3")
        currSelector = 3
        
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func selectPoint4(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot4")
        dotView.image = #imageLiteral(resourceName: "dot4")
        currSelector = 4
        
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func selectPoint5(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot5")
        dotView.image = #imageLiteral(resourceName: "dot5")
        currSelector = 5
        
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func confirmSelectionAction(_ sender: Any) {
        confirmSelection.isUserInteractionEnabled = false
        enableSelectionButtons()
        imageView.isUserInteractionEnabled = false
        zoomedView.isHidden = true
        
        points[currSelector - 1] = currentImageViewPoint
        
        updateNextButtonState()
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let nextController = segue.destination as? TPAViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        procedure?.points = points
        
        nextController.procedure = procedure
    }
    
    @IBAction func animate(_ sender: Any) {
        if(plusButton.image == #imageLiteral(resourceName: "PlusButtonBlue")){
            menuBotConstraint.constant = 0
            plusBotConstraint.constant += 300
            
            if(isTop){
                zoomBotConstraint.constant += 300
            }
            
            plusButton.image = #imageLiteral(resourceName: "DownButtonBlue")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            menuBotConstraint.constant = -300
            plusBotConstraint.constant -= 300
            
            if(isTop){
                zoomBotConstraint.constant -= 300
            }
            
            plusButton.image = #imageLiteral(resourceName: "PlusButtonBlue")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    
    //MARK: Private Methods
    private func disableSelectionButtons() {
        point1Button.isUserInteractionEnabled = false
        point2Button.isUserInteractionEnabled = false
        point3Button.isUserInteractionEnabled = false
        point4Button.isUserInteractionEnabled = false
        point5Button.isUserInteractionEnabled = false
    }
    
    private func enableSelectionButtons() {
        point1Button.isUserInteractionEnabled = true
        point2Button.isUserInteractionEnabled = true
        point3Button.isUserInteractionEnabled = true
        point4Button.isUserInteractionEnabled = true
        point5Button.isUserInteractionEnabled = true
    }
    
    private func updateNextButtonState() {
        if p1Chose && p2Chose && p3Chose && p4Chose && p5Chose {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }

}
