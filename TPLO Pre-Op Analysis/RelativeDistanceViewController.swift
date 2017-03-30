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
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var pointOneButton: UIButton!
    @IBOutlet weak var pointTwoButton: UIButton!
    @IBOutlet weak var confirmSelectionButton: UIButton!
    @IBOutlet weak var zoomedView: UIImageView!
    
    var pointOneCreated = false
    var pointTwoCreated = false
    
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNextButtonState()

        points.append(CGPoint(x: 0.0, y: 0.0))
        points.append(CGPoint(x: 0.0, y: 0.0))
        
        currentPoints.append(CGPoint(x: 0.0, y: 0.0))
        currentPoints.append(CGPoint(x: 0.0, y: 0.0))
        
        confirmSelectionButton.isEnabled = false
        
        guard let procedure = procedure else{
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
        
        
        procedure.imageViewWidth = imageViewWidth
        procedure.imageViewHeight = imageViewHeight
        
        imageView.addGestureRecognizer(zoomRecog)
        imageView.isUserInteractionEnabled = false
        imageView.image = radiographImage
        
        self.view.addSubview(imageView)
        
        dotView.image = currentDot
        dotView.frame = CGRect(x: zoomedViewWidth / 2  - 5, y: zoomedViewHeight / 2 - 5, width: 10, height: 10)
        
        zoomedViewWidth = zoomedView.frame.width
        zoomedViewHeight = zoomedView.frame.height
        
        zoomedView.addSubview(dotView)
        zoomedView.isHidden = true
        

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
        
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func selectPointTwo(_ sender: Any) {
        disableSelectionButtons()
        currentDot = #imageLiteral(resourceName: "dot2")
        dotView.image = #imageLiteral(resourceName: "dot2")
        currSelector = 2
        
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func confirmSelectedAction(_ sender: Any) {
        confirmSelectionButton.isEnabled = false
        imageView.isUserInteractionEnabled = false
        enableSelectionButtons()
        zoomedView.isHidden = true
        
        points[currSelector - 1] = currentImageViewPoint
        updateNextButtonState()
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
        pointOneButton.isEnabled = false
        pointTwoButton.isEnabled = false
    }
    
    private func enableSelectionButtons() {
        pointOneButton.isEnabled = true
        pointTwoButton.isEnabled = true
    }
    
    private func calcYPos() -> CGFloat {
        return buttonView.frame.origin.y + pointOneButton.frame.height + 10
    }
    
    private func maxAllowedHeight() -> CGFloat {
        return (zoomedView.frame.origin.y) - calcYPos()
    }
    
    @IBAction func tapDown(sender: ZoomGestureRecognizer) {
        zoomedView.isHidden = false
        let point = sender.location(in: imageView)
        zoomedView.image = getZoomedImage(point: point)
        
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
            
            confirmSelectionButton.isEnabled = true
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

}
