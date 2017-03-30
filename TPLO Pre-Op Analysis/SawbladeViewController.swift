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
    
    var radiographView = UIImageView()
    
    var imageViewWidth: CGFloat = 0.0, imageViewHeight: CGFloat = 0.0
    
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewWidth = procedure!.imageViewWidth
        imageViewHeight = procedure!.imageViewHeight
        
        
        let screenWidth = UIScreen.main.bounds.width
        
        radiographView.frame = CGRect(x: (screenWidth - imageViewWidth) / 2, y: (navigationController?.navigationBar.frame.height)! + 30, width: imageViewWidth, height: imageViewHeight)
        
        radiographView.isUserInteractionEnabled = false
        radiographView.image = procedure?.radiograph
        
        self.view.addSubview(radiographView)
        
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
        
        
        radiographView.image = procedure?.radiograph
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = drawSawbladeCircle(size: (procedure?.radiograph?.size)!)?.cgPath
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 1.0
        circleLayer.fillColor = UIColor.clear.cgColor
        
        radiographView.layer.addSublayer(circleLayer)
        
        outputLabel.text = String(format: "%dmm Size Sawblade and %.2fmm and %.2f pixels", roundedRadius!, sawbladeRadiusMM!, (procedure?.sawbladeRadius)!)

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
