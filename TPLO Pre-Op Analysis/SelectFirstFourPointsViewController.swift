//
//  SelectFirstFourPointsViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Erik Melone on 1/31/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class SelectFirstFourPointsViewController: UIViewController {

    //MARK: Properties
    
    var procedure : Procedure?
    var currentPoint = CGPoint(x: 0.0, y: 0.0)
    var points = [CGPoint]()
    var currSelector = 0
    
    @IBOutlet weak var point1Button: UIButton!
    @IBOutlet weak var point2Button: UIButton!
    @IBOutlet weak var point3Button: UIButton!
    @IBOutlet weak var point4Button: UIButton!
    @IBOutlet weak var point5Button: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var confirmSelection: UIButton!
    
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
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        
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
        
        confirmSelection.isEnabled = false
        
        guard let procedure = procedure else {
            fatalError("Procedure was not correctly passed to Relative Distance Controller")
        }
        
        radiographImage = procedure.radiograph!
        
        imageWidth = CGFloat((radiographImage.cgImage?.width)!)
        imageHeight = CGFloat((radiographImage.cgImage?.height)!)
        imageRatio = imageWidth / imageHeight
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        imageViewWidth = screenWidth - 40
        imageViewHeight = imageViewWidth / imageRatio
        
        if(imageViewHeight > maxAllowedHeight()) {
            imageViewHeight = maxAllowedHeight()
            imageViewWidth = imageViewHeight * imageRatio
            imageView.frame = CGRect(x: (screenWidth - imageViewWidth) / 2, y: calcYPos(), width: imageViewWidth, height: imageViewHeight)
        } else {
            imageView.frame = CGRect(x: 20, y: calcYPos(), width: imageViewWidth, height: imageViewHeight)
        }
        
        imageView.addGestureRecognizer(zoomRecog)
        imageView.isUserInteractionEnabled = false
        imageView.image = radiographImage
        
        self.view.addSubview(imageView)
        
        dotView.image = currentDot
        dotView.frame = CGRect(x: zoomedViewWidth / 2  - 5, y: zoomedViewHeight / 2 - 5, width: 10, height: 10)
        
        zoomedViewWidth = zoomedView.frame.width
        zoomedViewHeight = zoomedView.frame.height
        
        zoomedView.addSubview(dotView)
        zoomedView.layer.zPosition = -20
        zoomedView.isHidden = true

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
            zoomedView.isHidden = true
            
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
            
            confirmSelection.isEnabled = true
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
        
        if p1Chose {
            confirmSelection.isEnabled = true
        }
    }
    
    @IBAction func selectPoint2(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot2")
        dotView.image = #imageLiteral(resourceName: "dot2")
        currSelector = 2
        
        imageView.isUserInteractionEnabled = true
        
        if p2Chose {
            confirmSelection.isEnabled = true
        }
    }
    
    @IBAction func selectPoint3(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot3")
        dotView.image = #imageLiteral(resourceName: "dot3")
        currSelector = 3
        
        imageView.isUserInteractionEnabled = true
        
        if p3Chose {
            confirmSelection.isEnabled = true
        }
    }
    
    @IBAction func selectPoint4(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot4")
        dotView.image = #imageLiteral(resourceName: "dot4")
        currSelector = 4
        
        imageView.isUserInteractionEnabled = true
        
        if p4Chose {
            confirmSelection.isEnabled = true
        }
    }
    
    @IBAction func selectPoint5(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot5")
        dotView.image = #imageLiteral(resourceName: "dot5")
        currSelector = 5
        
        imageView.isUserInteractionEnabled = true
        
        if p5Chose {
            confirmSelection.isEnabled = true
        }
    }
    
    @IBAction func confirmSelectionAction(_ sender: Any) {
        confirmSelection.isEnabled = false
        enableSelectionButtons()
        imageView.isUserInteractionEnabled = false
        
        points[currSelector - 1] = currentImageViewPoint
        
        updateNextButtonState()
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
    
    //MARK: Private Methods
    private func disableSelectionButtons() {
        point1Button.isEnabled = false
        point2Button.isEnabled = false
        point3Button.isEnabled = false
        point4Button.isEnabled = false
        point5Button.isEnabled = false
    }
    
    private func enableSelectionButtons() {
        point1Button.isEnabled = true
        point2Button.isEnabled = true
        point3Button.isEnabled = true
        point4Button.isEnabled = true
        point5Button.isEnabled = true
    }
    
    private func updateNextButtonState() {
        if p1Chose && p2Chose && p3Chose && p4Chose && p5Chose {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    private func calcYPos() -> CGFloat {
        return (navigationController?.navigationBar.frame.height)! + 30
    }
    
    private func maxAllowedHeight() -> CGFloat {
        return (zoomedView.frame.origin.y - 10) - calcYPos()
    }

}
