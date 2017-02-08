//
//  OsteotomyViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 2/6/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class OsteotomyViewController: UIViewController {

    //MARK: Properties
    var procedure : Procedure?
    var maskImage : UIImage?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var radiographImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let procedure = procedure else {
            fatalError("Procedure was not correctly passed to Osteotomy Controller")
        }
        
        let maskPath = drawMaskImage(size: (procedure.radiograph?.size)!)
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = maskPath?.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        radiographImage.image = procedure.radiograph
        radiographImage.layer.mask = maskLayer
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func drawMaskImage(size: CGSize) -> UIBezierPath? {
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        
        let polygon = UIBezierPath()
        
        polygon.move(to: CGPoint(x: (procedure?.points[0].x)!, y: (procedure?.points[0].y)!))
        polygon.addLine(to: CGPoint(x: (procedure?.points[1].x)!, y: (procedure?.points[1].y)!))
        polygon.addLine(to: CGPoint(x: (procedure?.points[4].x)!, y: (procedure?.points[4].y)!))
        polygon.addLine(to: CGPoint(x: (procedure?.points[3].x)!, y: (procedure?.points[3].y)!))
        polygon.addLine(to: CGPoint(x: (procedure?.points[2].x)!, y: (procedure?.points[2].y)!))
        polygon.addLine(to: CGPoint(x: (procedure?.points[0].x)!, y: (procedure?.points[0].y)!))
        
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

}
