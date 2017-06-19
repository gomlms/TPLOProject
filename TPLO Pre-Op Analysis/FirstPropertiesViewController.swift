//
//  PictureViewController.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 1/16/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit
import os.log

class FirstPropertiesViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    var nameTextField: UITextField = UITextField()
    @IBOutlet weak var imageSelector: UIImageView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var menuTopConstraint: NSLayoutConstraint!
    var markerButton: UIImageView = UIImageView(image: #imageLiteral(resourceName: "100mmMarkerGrey"))
    var ballButton: UIImageView = UIImageView(image: #imageLiteral(resourceName: "25mmBallGrey"))
    
    var markerTap : UITapGestureRecognizer = UITapGestureRecognizer()
    var ballTap : UITapGestureRecognizer = UITapGestureRecognizer()
    
    @IBOutlet weak var menuView: UIImageView!
    @IBOutlet weak var gradient: UIImageView!
    
    var imageView: UIImageView = UIImageView()
    var imageRatio: CGFloat = 0
    var imageViewWidth: CGFloat = 0
    var imageViewHeight: CGFloat = 0
    var imageViewXOrigin: CGFloat = 0
    var imageViewYOrigin: CGFloat = 0
    
    
    var procedure : Procedure?
    var designator: String?
    
    
    //var currentProcedure : Procedure = nil
    var radiographImage : UIImage = #imageLiteral(resourceName: "defaultPhoto")
    
    var chosePicture = false
    var desChosen = false
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.view.backgroundColor = UIColor.black
        
        scheduledTimerWithInterval()
        
        markerTap.addTarget(self, action: #selector(FirstPropertiesViewController.markerPressed(_:)))
        ballTap.addTarget(self, action: #selector(FirstPropertiesViewController.ballPressed(_:)))
        
        menuTopConstraint.constant = -200
        
        updateNextButtonState()
        // Do any additional setup after loading the view.
        nextButton.isEnabled = false
        
        nameTextField.delegate = self
        
        if let procedure = procedure {
            nameTextField.text = procedure.name
            imageSelector.image = procedure.radiograph
        }
        
        //Hide Keyboard
        nameTextField.resignFirstResponder()
        
        //UIImagePickerController allows user to choose photo from storage
        let imagePickerController = UIImagePickerController()
        
        //Only allow Images to be chosen
        imagePickerController.sourceType = .photoLibrary
        
        //Make Sure view controller is notified when photo is chosen
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func scheduledTimerWithInterval(){
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.animateMenu), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(desChosen){
            performSegue(withIdentifier: "Continue", sender: self)
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateNextButtonState()
    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem){
        let isPresentingInNewProcedureMode = presentingViewController is UINavigationController
        
        if isPresentingInNewProcedureMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The Properties View Controller is not inside a navigation controller")
        }
        updateNextButtonState()
    }
    
    @IBAction func markerPressed(_ sender: Any) {
        designator = "Marker"
        markerButton.image = #imageLiteral(resourceName: "100mmMarkerButton")
        ballButton.image = #imageLiteral(resourceName: "25mmBallGrey")
        desChosen = true
        updateNextButtonState()
        
        
        if(nameTextField.text != " Enter patient name..."){
            let name = nameTextField.text ?? ""
            let photo = radiographImage
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateStyle = DateFormatter.Style.long
            let currentDate = dateFormatter.string(from: date)
            
            procedure = Procedure(n: name, r: photo, d: currentDate, m: designator!, p1: [CGPoint](), i1: "0,0", s1: 0.0, s2: 0, s3: "", c1: 0.0, p2: "", p3: 0.0, r1: 0, a1: 0.0, r2: UIView(), s4: photo, i2: 0.0, i3: 0.0, i4: 0.0, i5: 0.0, p4: nil, t1: 0.0)
        }
        
        if(procedure?.name !=  " Enter patient name..." && procedure?.name != nil){
            performSegue(withIdentifier: "Continue", sender: self)
        }
    }
    
    @IBAction func ballPressed(_ sender: Any) {
        designator = "Ball"
        markerButton.image = #imageLiteral(resourceName: "100mmMarkerGrey")
        ballButton.image = #imageLiteral(resourceName: "25mmBallButton")
        desChosen = true
        updateNextButtonState()
        
        if(nameTextField.text != " Enter patient name..."){
            let name = nameTextField.text ?? ""
            let photo = radiographImage
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateStyle = DateFormatter.Style.long
            let currentDate = dateFormatter.string(from: date)
            
            procedure = Procedure(n: name, r: photo, d: currentDate, m: designator!, p1: [CGPoint](), i1: "0,0", s1: 0.0, s2: 0, s3: "", c1: 0.0, p2: "", p3: 0.0, r1: 0, a1: 0.0, r2: UIView(), s4: photo, i2: 0.0, i3: 0.0, i4: 0.0, i5: 0.0, p4: nil, t1: 0.0)
        }

        if(procedure?.name !=  " Enter patient name..." && procedure?.name != nil){
            performSegue(withIdentifier: "Continue", sender: self)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        chosePicture = false
        
        procedure?.imageViewWidth = imageViewWidth
        procedure?.imageViewHeight  = imageViewHeight
        procedure?.imageViewXOrigin = imageViewXOrigin
        procedure?.imageViewYOrigin = imageViewYOrigin
        
        if segue.identifier == "Continue" {
            guard let procedureDataViewController = segue.destination as? RelativeDistanceViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            procedureDataViewController.procedure = procedure
        }
        super.prepare(for: segue, sender: sender)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        //Hide Keyboard
        nameTextField.resignFirstResponder()
        
        //UIImagePickerController allows user to choose photo from storage
        let imagePickerController = UIImagePickerController()
        
        //Only allow Images to be chosen
        imagePickerController.sourceType = .photoLibrary
        
        //Make Sure view controller is notified when photo is chosen
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func fixOrientation(image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        if image.imageOrientation == UIImageOrientation.up {
            return image
        }
        
        let width  = image.size.width
        let height = image.size.height
        
        var transform = CGAffineTransform.identity
        
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: CGFloat.pi)
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: 0.5*CGFloat.pi)
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: -0.5*CGFloat.pi)
            
        case .up, .upMirrored:
            break
        }
        
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let colorSpace = cgImage.colorSpace else {
            return nil
        }
        
        guard let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: UInt32(cgImage.bitmapInfo.rawValue)
            ) else {
                return nil
        }
        
        context.concatenate(transform);
        
        switch image.imageOrientation {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
            
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let newCGImg = context.makeImage() else {
            return nil
        }
        
        let img = UIImage(cgImage: newCGImg)
        
        return img;
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //The info dictionary may contain multiple representations of the image. You want to use the original
        guard var selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        selectedImage = fixOrientation(image: selectedImage)!
        
        //Set Photo Image to display the selected image view
        radiographImage = selectedImage
        procedure?.radiograph = selectedImage
        
        chosePicture = true
        dismiss(animated: true, completion: nil)
    
        gradient.isHidden = true
        
        imageView.image = radiographImage
        imageRatio = radiographImage.size.width / radiographImage.size.height
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        let desiredAspect = screenWidth / screenHeight
        let rectAspect = (radiographImage.size.width) / (radiographImage.size.height)
        let scaleFactor: CGFloat?
        var x: CGFloat = 0.0, y: CGFloat = 0.0
        
        if(desiredAspect > rectAspect) {
            scaleFactor = screenHeight / (radiographImage.size.height)
            x = (screenWidth - ((radiographImage.size.width) * scaleFactor!)) / 2
        } else {
            scaleFactor = screenWidth / (radiographImage.size.width)
            y = ((screenHeight - UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!) - ((radiographImage.size.height) * scaleFactor!)) / 2
        }
        
        
        
        imageViewXOrigin = x
        imageViewYOrigin = y
        imageViewWidth = radiographImage.size.width * scaleFactor!
        imageViewHeight = radiographImage.size.height * scaleFactor!
        
        /*imageViewHeight = screenHeight
         imageViewWidth = imageViewHeight * imageRatio
         
         imageViewXOrigin = (screenWidth - imageViewWidth) / 2.0*/
        
        imageView.frame = CGRect(x: imageViewXOrigin, y: imageViewYOrigin, width: imageViewWidth, height: imageViewHeight)
        
        self.view.addSubview(imageView)
        
        nameTextField.frame = CGRect(x: 25, y: 20, width: menuView.frame.width - 50, height: 30)
        nameTextField.text = " Enter patient name..."
        nameTextField.font = UIFont(name:"Open Sans", size: 16)
        nameTextField.backgroundColor = UIColor.white
        nameTextField.layer.zPosition = 5
        nameTextField.isUserInteractionEnabled = true
        nameTextField.clearsOnBeginEditing = true
        
        menuView.addSubview(nameTextField)
        
        markerButton.frame = CGRect(x: 20, y: 80, width: (menuView.frame.width - 70) / 2.0, height: 80)
        ballButton.frame = CGRect(x: 50 + markerButton.frame.width, y: 80, width: (menuView.frame.width - 70) / 2.0, height: 80)
        
        markerButton.contentMode = UIViewContentMode.scaleAspectFit
        ballButton.contentMode = UIViewContentMode.scaleAspectFit
        
        markerButton.isUserInteractionEnabled = true
        ballButton.isUserInteractionEnabled = true
        
        markerButton.addGestureRecognizer(markerTap)
        ballButton.addGestureRecognizer(ballTap)
        
        menuView.addSubview(markerButton)
        menuView.addSubview(ballButton)
        
        imageView.layer.zPosition = -1
    }
    
    @objc private func animateMenu() {
        
        if(chosePicture){
            menuTopConstraint.constant = (self.navigationController?.navigationBar.frame.size.height)!
    
            UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            })
            
            chosePicture = false
        }
    }
    
    //MARK: Private Methods
    private func updateNextButtonState() {
        
    }
}
