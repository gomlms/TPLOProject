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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let hRatio = self.innerView.frame.height / 300.0
        
        print("\(currHeight) \(self.innerView.frame.height)")
        
        if(currHeight != self.innerView.frame.height){
            if(currHeight > self.innerView.frame.height){
                dot1.frame = CGRect(x: dot1.frame.origin.x, y: dot1.frame.origin.y, width: 20 * hRatio, height: 20 * hRatio)
                dot1.center = currentPoints[0]
                currHeight = self.innerView.frame.height
            } else {
                dot1.frame = CGRect(x: dot1.frame.origin.x, y: dot1.frame.origin.y, width: 20 / hRatio, height: 20 / hRatio)
                dot1.center = currentPoints[0]
                currHeight = self.innerView.frame.height
            }
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
        case 2:
            dot2.center = currentPoint
            dot2.isHidden = false
            currentPoints[1] = currentPoint
        case 3:
            dot3.center = currentPoint
            dot3.isHidden = false
            currentPoints[2] = currentPoint
        case 4:
            dot4.center = currentPoint
            dot4.isHidden = false
            currentPoints[3] = currentPoint
        case 5:
            dot5.center = currentPoint
            dot5.isHidden = false
            currentPoints[4] = currentPoint
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
    }
    
    @IBAction func selectPoint2(_ sender: Any) {
        disableSelectionButtons()
        imageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #2"
        currSelector = 2
    }
    
    @IBAction func selectPoint3(_ sender: Any) {
        disableSelectionButtons()
        imageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #3"
        currSelector = 3
    }
    
    @IBAction func selectPoint4(_ sender: Any) {
        disableSelectionButtons()
        imageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #4"
        currSelector = 4
    }
    
    @IBAction func selectPoint5(_ sender: Any) {
        disableSelectionButtons()
        imageView.isUserInteractionEnabled = true
        outputLabel.text = "Selecting for Point #5"
        currSelector = 5
    }
    
    @IBAction func confirmSelectionAction(_ sender: Any) {
        confirmSelection.isEnabled = false
        enableSelectionButtons()
        imageView.isUserInteractionEnabled = false
        outputLabel.text = "Point #\(currSelector) Set!"
        
        points[currSelector - 1] = currentPoint
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
    

}
