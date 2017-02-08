//
//  SawbladeViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 2/6/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class SawbladeViewController: UIViewController {

    //MARK: Properties
    var procedure : Procedure?
    var sawbladeRadiusMM : Double?
    var roundedRadius : Int?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var radiographView: UIImageView!
    
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xSquared = Double(pow(((procedure?.points[4].x)! - (procedure?.points[0].x)!), 2))
        
        let ySquared = Double(pow(((procedure?.points[4].y)! - (procedure?.points[0].y)!), 2))
        
        procedure?.sawbladeRadius = sqrt(xSquared + ySquared)
        
        sawbladeRadiusMM = (procedure?.sawbladeRadius)! * (procedure?.pixelToMMRatio)!
        
        if(sawbladeRadiusMM! >= 15.0 && sawbladeRadiusMM! < 16.5){
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
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        radiographView.image = procedure?.radiograph
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = drawSawbladeCircle(size: (procedure?.radiograph?.size)!)?.cgPath
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 1.0
        circleLayer.fillColor = UIColor.clear.cgColor
        
        radiographView.layer.addSublayer(circleLayer)
        
        outputLabel.text = "\(roundedRadius!)mm Size Sawblade and \(sawbladeRadiusMM)mm and \(procedure?.sawbladeRadius) pixels"

        // Do any additional setup after loading the view.
    }
    
    func drawSawbladeCircle(size:CGSize) -> UIBezierPath? {
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        
        let sawbladeCircle = UIBezierPath()
        
        sawbladeCircle.addArc(withCenter: CGPoint(x: (procedure?.points[0].x)!, y: (procedure?.points[0].y)!), radius: CGFloat(Float(roundedRadius!)), startAngle: 0.0, endAngle: CGFloat(2.0 * 3.141592), clockwise: true)
        
        UIGraphicsEndImageContext()
        
        return sawbladeCircle
    }
    
    //MARK: ScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.innerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let nextController = segue.destination as? OsteotomyViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
            
        nextController.procedure = procedure
    }

}
