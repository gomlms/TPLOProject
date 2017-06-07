//
//  SetSawbladeViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 6/7/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class SetSawbladeViewController: UIViewController {

    var procedure : Procedure?
    
    var point1Button = UIView()
    var point2Button = UIView()
    var point3Button = UIView()
    var point31Button = UIView()
    var point4Button = UIView()
    var point5Button = UIView()
    var confirmSelection = UIView()
    var point8Button = UIView()
    
    var button1Recog = UITapGestureRecognizer()
    var button2Recog = UITapGestureRecognizer()
    var button3Recog = UITapGestureRecognizer()
    var button31Recog = UITapGestureRecognizer()
    var button4Recog = UITapGestureRecognizer()
    var button5Recog = UITapGestureRecognizer()
    var confirmRecog = UITapGestureRecognizer()
    var button8Recog = UITapGestureRecognizer()
    
    var selectedColor : UIColor = UIColor(red:0.00, green:0.74, blue:0.89, alpha:0.7)
    var unselectedColor : UIColor = UIColor(red:0.00, green:0.32, blue:0.61, alpha:0.7)
    var greyColor : UIColor = UIColor(red:0.27, green:0.35, blue:0.34, alpha:1.0)
    
    @IBOutlet weak var plusButton: UIImageView!
    
    @IBOutlet weak var plusBotConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuView: UIImageView!

    @IBOutlet weak var menuBotConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = screenWidth / 4.0
        
        point1Button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot1Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 3, width: buttonWidth * 4 / 5, height: 60))
        dot1Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot1Label.numberOfLines = 0
        dot1Label.font = UIFont(name:"Open Sans", size: 20)
        dot1Label.textColor = UIColor.white
        dot1Label.textAlignment = .center
        dot1Label.text = "12mm\n Sawblade"
        
        point1Button.layer.borderColor = UIColor.gray.cgColor
        point1Button.layer.borderWidth = 2.0
        point1Button.layer.shadowRadius = 10.0
        point1Button.addSubview(dot1Label)
        
        menuView.addSubview(point1Button)
        
        point2Button.frame = CGRect(x: buttonWidth, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot2Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 3, width: buttonWidth * 4 / 5, height: 60))
        dot2Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot2Label.numberOfLines = 0
        dot2Label.font = UIFont(name:"Open Sans", size: 16)
        dot2Label.textColor = UIColor.white
        dot2Label.textAlignment = .center
        dot2Label.text = "Center\nOf Talus"
        
        point2Button.layer.borderColor = UIColor.gray.cgColor
        point2Button.layer.borderWidth = 2.0
        point2Button.layer.shadowRadius = 10.0
        
        point2Button.addSubview(dot2Label)
        
        menuView.addSubview(point2Button)
        
        point3Button.frame = CGRect(x: 2 * buttonWidth, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot3Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 3, width: buttonWidth * 4 / 5, height: 60))
        dot3Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot3Label.numberOfLines = 0
        dot3Label.font = UIFont(name:"Open Sans", size: 16)
        dot3Label.textColor = UIColor.white
        dot3Label.textAlignment = .center
        dot3Label.text = "Tibial Plateau\nCranial"
        
        point3Button.layer.borderColor = UIColor.gray.cgColor
        point3Button.layer.borderWidth = 2.0
        point3Button.layer.shadowRadius = 10.0
        
        point3Button.addSubview(dot3Label)
        
        menuView.addSubview(point3Button)
        
        point31Button.frame = CGRect(x: 3 * buttonWidth, y: 0, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot31Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 3, width: buttonWidth * 4 / 5, height: 60))
        dot31Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot31Label.numberOfLines = 0
        dot31Label.font = UIFont(name:"Open Sans", size: 16)
        dot31Label.textColor = UIColor.white
        dot31Label.textAlignment = .center
        dot31Label.text = "Tibial Plateau\nCranial"
        
        point31Button.layer.borderColor = UIColor.gray.cgColor
        point31Button.layer.borderWidth = 2.0
        point31Button.layer.shadowRadius = 10.0
        
        point31Button.addSubview(dot31Label)
        
        menuView.addSubview(point31Button)
        
        
        point4Button.frame = CGRect(x: 0, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot4Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 3, width: buttonWidth * 4 / 5, height: 60))
        dot4Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot4Label.numberOfLines = 0
        dot4Label.font = UIFont(name:"Open Sans", size: 16)
        dot4Label.textColor = UIColor.white
        dot4Label.textAlignment = .center
        dot4Label.text = "Tibial Plateau\nCaudal"
        
        point4Button.layer.borderColor = UIColor.gray.cgColor
        point4Button.layer.borderWidth = 2.0
        point4Button.layer.shadowRadius = 10.0
        
        point4Button.addSubview(dot4Label)
        
        menuView.addSubview(point4Button)
        
        point5Button.frame = CGRect(x: buttonWidth, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot5Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 3, width: buttonWidth * 4 / 5, height: 60))
        dot5Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot5Label.numberOfLines = 0
        dot5Label.font = UIFont(name:"Open Sans", size: 16)
        dot5Label.textColor = UIColor.white
        dot5Label.textAlignment = .center
        dot5Label.text = "Proximal\nTubercle"
        
        point5Button.layer.borderColor = UIColor.gray.cgColor
        point5Button.layer.borderWidth = 2.0
        point5Button.layer.shadowRadius = 10.0
    
        point5Button.addSubview(dot5Label)
        
        menuView.addSubview(point5Button)
        
        confirmSelection.frame = CGRect(x: 2 * buttonWidth, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let confirmLabel = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 3, width: buttonWidth * 4 / 5, height: 60))
        confirmLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        confirmLabel.numberOfLines = 0
        confirmLabel.font = UIFont(name:"Open Sans", size: 16)
        confirmLabel.textColor = UIColor.white
        confirmLabel.textAlignment = .center
        confirmLabel.text = "Continue"
        
        confirmSelection.layer.borderColor = UIColor.gray.cgColor
        confirmSelection.layer.borderWidth = 2.0
        confirmSelection.layer.shadowRadius = 10.0
        
        confirmSelection.addSubview(confirmLabel)
        
        menuView.addSubview(confirmSelection)
        
        point8Button.frame = CGRect(x: 3 * buttonWidth, y: menuView.frame.height / 2, width: buttonWidth, height: menuView.frame.height / 2)
        
        let dot8Label = UILabel(frame: CGRect(x: buttonWidth / 10, y: buttonWidth / 3, width: buttonWidth * 4 / 5, height: 60))
        dot8Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        dot8Label.numberOfLines = 0
        dot8Label.font = UIFont(name:"Open Sans", size: 16)
        dot8Label.textColor = UIColor.white
        dot8Label.textAlignment = .center
        dot8Label.text = "Proximal\nTubercle"
        
        point8Button.layer.borderColor = UIColor.gray.cgColor
        point8Button.layer.borderWidth = 2.0
        point8Button.layer.shadowRadius = 10.0
        
        point8Button.addSubview(dot8Label)
        
        menuView.addSubview(point8Button)

        
        menuView.isUserInteractionEnabled = true
        point1Button.isUserInteractionEnabled = true
        point2Button.isUserInteractionEnabled = true
        point3Button.isUserInteractionEnabled = true
        point4Button.isUserInteractionEnabled = true
        point5Button.isUserInteractionEnabled = true
        confirmSelection.isUserInteractionEnabled = false
        
        
        button1Recog.addTarget(self, action: #selector(SetSawbladeViewController.Blade12(_:)))
        button2Recog.addTarget(self, action: #selector(SetSawbladeViewController.Blade15(_:)))
        button3Recog.addTarget(self, action: #selector(SetSawbladeViewController.Blade18(_:)))
        button3Recog.addTarget(self, action: #selector(SetSawbladeViewController.Blade21(_:)))
        button4Recog.addTarget(self, action: #selector(SetSawbladeViewController.Blade24(_:)))
        button5Recog.addTarget(self, action: #selector(SetSawbladeViewController.Blade27(_:)))
        confirmRecog.addTarget(self, action: #selector(SetSawbladeViewController.Blade30(_:)))
        button8Recog.addTarget(self, action: #selector(SetSawbladeViewController.Blade33(_:)))
        
        point1Button.addGestureRecognizer(button1Recog)
        point2Button.addGestureRecognizer(button2Recog)
        point3Button.addGestureRecognizer(button3Recog)
        point31Button.addGestureRecognizer(button31Recog)
        point4Button.addGestureRecognizer(button4Recog)
        point5Button.addGestureRecognizer(button5Recog)
        confirmSelection.addGestureRecognizer(confirmRecog)
        point8Button.addGestureRecognizer(button8Recog)
        
        point1Button.backgroundColor = unselectedColor
        point2Button.backgroundColor = unselectedColor
        point3Button.backgroundColor = unselectedColor
        point4Button.backgroundColor = unselectedColor
        point5Button.backgroundColor = unselectedColor
        point31Button.backgroundColor = unselectedColor
        point8Button.backgroundColor = unselectedColor
        confirmSelection.backgroundColor = greyColor

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Blade12(_ sender: Any){
    
    }
    
    @IBAction func Blade15(_ sender: Any){
        
    }
    
    @IBAction func Blade18(_ sender: Any){
        
    }
    
    @IBAction func Blade21(_ sender: Any){
        
    }
    
    @IBAction func Blade24(_ sender: Any){
        
    }
    
    @IBAction func Blade27(_ sender: Any){
        
    }
    
    @IBAction func Blade30(_ sender: Any){
        
    }
    
    @IBAction func Blade33(_ sender: Any){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func animate(_ sender: Any) {
        if(plusButton.image! == #imageLiteral(resourceName: "PlusButtonBlue") || plusBotConstraint.constant == 20.0){
            menuBotConstraint.constant = 0
            plusBotConstraint.constant += 300
            
            plusButton.image = #imageLiteral(resourceName: "DownButtonBlue")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            menuBotConstraint.constant = -300
            plusBotConstraint.constant -= 300
        
            
            plusButton.image = #imageLiteral(resourceName: "PlusButtonBlue")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let nextController = segue.destination as? TPAViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        nextController.procedure = procedure
    }
 

}
