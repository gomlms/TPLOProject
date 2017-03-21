//
//  SelectFirstFourPointsViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Erik Melone on 1/31/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class SelectFirstFourPointsViewController: UIViewController, UIScrollViewDelegate {

    //MARK: Properties
    
    var procedure : Procedure?
    var currentPoint = CGPoint(x: 0.0, y: 0.0)
    var points = [CGPoint]()
    var currSelector = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var point1Button: UIButton!
    @IBOutlet weak var point2Button: UIButton!
    @IBOutlet weak var point3Button: UIButton!
    @IBOutlet weak var point4Button: UIButton!
    @IBOutlet weak var point5Button: UIButton!
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var confirmSelection: UIButton!
    
    @IBOutlet weak var dot1: UIImageView!
    @IBOutlet weak var dot2: UIImageView!
    @IBOutlet weak var dot3: UIImageView!
    @IBOutlet weak var dot4: UIImageView!
    @IBOutlet weak var dot5: UIImageView!
    
    var radiographImage : UIImage?
    
    var currentPoints = [CGPoint]()
    var currHeight : CGFloat = 300
    
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
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        radiographImage = procedure.radiograph
        
        imageView.image = radiographImage
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
            
            dot3.frame = CGRect(x: dot3.frame.origin.x, y: dot3.frame.origin.y, width: dot3.frame.size.width / hRatio, height: dot3.frame.size.height / hRatio)
            dot3.center = currentPoints[2]
            
            dot4.frame = CGRect(x: dot4.frame.origin.x, y: dot4.frame.origin.y, width: dot4.frame.size.width / hRatio, height: dot4.frame.size.height / hRatio)
            dot4.center = currentPoints[3]
            
            dot5.frame = CGRect(x: dot5.frame.origin.x, y: dot5.frame.origin.y, width: dot5.frame.size.width / hRatio, height: dot5.frame.size.height / hRatio)
            dot5.center = currentPoints[4]
            
            currHeight = self.innerView.frame.height
        }
        
        return self.innerView
    }
    
    //MARK: Action
    @IBAction func tapForPoint(_ sender: UITapGestureRecognizer) {
        confirmSelection.isEnabled = true
        currentPoint = sender.location(in: imageView)
        
        switch currSelector {
        case 1:
            dot1.center = currentPoint
            dot1.isHidden = false
            currentPoints[0] = currentPoint
            p1Chose = true
        case 2:
            dot2.center = currentPoint
            dot2.isHidden = false
            currentPoints[1] = currentPoint
            p2Chose = true
        case 3:
            dot3.center = currentPoint
            dot3.isHidden = false
            currentPoints[2] = currentPoint
            p3Chose = true
        case 4:
            dot4.center = currentPoint
            dot4.isHidden = false
            currentPoints[3] = currentPoint
            p4Chose = true
        case 5:
            dot5.center = currentPoint
            dot5.isHidden = false
            currentPoints[4] = currentPoint
            p5Chose = true
        default:
            fatalError()
        }
    }
    
    //MARK: SelectionButtonsActions
    
    @IBAction func selectPoint1(_ sender: Any) {
        disableSelectionButtons()
        imageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #1"
        currSelector = 1
        if p1Chose {
            confirmSelection.isEnabled = true
        }
    }
    
    @IBAction func selectPoint2(_ sender: Any) {
        disableSelectionButtons()
        imageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #2"
        currSelector = 2
        if p2Chose {
            confirmSelection.isEnabled = true
        }
    }
    
    @IBAction func selectPoint3(_ sender: Any) {
        disableSelectionButtons()
        imageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #3"
        currSelector = 3
        if p3Chose {
            confirmSelection.isEnabled = true
        }
    }
    
    @IBAction func selectPoint4(_ sender: Any) {
        disableSelectionButtons()
        imageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #4"
        currSelector = 4
        if p4Chose {
            confirmSelection.isEnabled = true
        }
    }
    
    @IBAction func selectPoint5(_ sender: Any) {
        disableSelectionButtons()
        imageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #5"
        currSelector = 5
        if p5Chose {
            confirmSelection.isEnabled = true
        }
    }
    
    @IBAction func confirmSelectionAction(_ sender: Any) {
        confirmSelection.isEnabled = false
        enableSelectionButtons()
        imageView.isUserInteractionEnabled = false
        outputLabel.text = "Point #\(currSelector) Set!"
        
        points[currSelector - 1] = currentPoint
        
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

}
