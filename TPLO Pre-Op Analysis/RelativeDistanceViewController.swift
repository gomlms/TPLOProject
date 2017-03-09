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
    var currentPoint = CGPoint(x: 0.0, y: 0.0)
    var points = [CGPoint]()
    var currSelector = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var radiographImageView: UIImageView!
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var pointOneButton: UIButton!
    @IBOutlet weak var pointTwoButton: UIButton!
    
    @IBOutlet weak var dot1: UIImageView!
    @IBOutlet weak var dot2: UIImageView!
    
    @IBOutlet weak var confirmSelectionButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    
    var pointOneCreated = false
    var pointTwoCreated = false
    
    var radiographImage : UIImage?
    
    var currentPoints = [CGPoint]()
    var currHeight : CGFloat = 300
    
    
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

        points.append(CGPoint(x: 0.0, y: 0.0))
        points.append(CGPoint(x: 0.0, y: 0.0))
        
        currentPoints.append(CGPoint(x: 0.0, y: 0.0))
        currentPoints.append(CGPoint(x: 0.0, y: 0.0))
        
        confirmSelectionButton.isEnabled = false
        
        guard let procedure = procedure else{
            fatalError("Procedure was not correctly passed to Relative Distance Controller")
        }
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        radiographImage = procedure.radiograph

        radiographImageView.image = radiographImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let hRatio = self.innerView.frame.height / currHeight
        
        if(currHeight != self.innerView.frame.height){
            dot1.frame = CGRect(x: dot1.frame.origin.x, y: dot1.frame.origin.y, width: dot1.frame.size.width / hRatio, height: dot1.frame.size.height / hRatio)
            dot1.center = currentPoints[0]

            dot2.frame = CGRect(x: dot2.frame.origin.x, y: dot2.frame.origin.y, width: dot2.frame.size.width / hRatio, height: dot2.frame.size.height / hRatio)
            dot2.center = currentPoints[1]
            
            currHeight = self.innerView.frame.height
        }
        
        return self.innerView
    }
    
    //MARK: Action
    
    @IBAction func tapForPoint(_ sender: UITapGestureRecognizer) {
        confirmSelectionButton.isEnabled = true
        currentPoint = sender.location(in: radiographImageView)
        
        switch currSelector {
        case 1:
            dot1.center = currentPoint
            dot1.isHidden = false
            pointOneCreated = true
            currentPoints[0] = currentPoint
        case 2:
            dot2.center = currentPoint
            dot2.isHidden = false
            pointTwoCreated = true
            currentPoints[1] = currentPoint
        default:
            fatalError("Tapping for points has failed")
        }
    }
    
    //MARK: SelectionButtonsActions

    @IBAction func selectPointOne(_ sender: Any) {
        disableSelectionButtons()
        radiographImageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #1"
        currSelector = 1
    }
    
    @IBAction func selectPointTwo(_ sender: Any) {
        disableSelectionButtons()
        radiographImageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #1"
        currSelector = 2
    }
    
    @IBAction func confirmSelectionAction(_ sender: Any) {
        confirmSelectionButton.isEnabled = false
        enableSelectionButtons()
        radiographImageView.isUserInteractionEnabled = false
        outputLabel.text = "Point #\(currSelector) Set!"
        
        points[currSelector - 1] = currentPoint
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
}
