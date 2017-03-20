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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageSelector: UIImageView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var markerButton: UIButton!
    @IBOutlet weak var ballButton: UIButton!
    
    @IBOutlet weak var titleBar: UILabel!
    
    
    var procedure : Procedure?
    var designator: String?
    
    //var currentProcedure : Procedure = nil
    var radiographImage : UIImage = #imageLiteral(resourceName: "defaultPhoto")
    
    var chosePicture = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateNextButtonState()
        // Do any additional setup after loading the view.
        
        nameTextField.delegate = self
        
        if let procedure = procedure {
            nameTextField.text = procedure.name
            imageSelector.image = procedure.radiograph
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //updateNextButtonState()
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
    }
    
    @IBAction func markerPressed(_ sender: Any) {
        designator = "Marker"
        markerButton.backgroundColor = UIColor.cyan
        ballButton.backgroundColor = UIColor.white
    }
    
    @IBAction func ballPressed(_ sender: Any) {
        designator = "Ball"
        ballButton.backgroundColor = UIColor.cyan
        markerButton.backgroundColor = UIColor.white
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === nextButton else {
            os_log("The next button was not pressed, cancelling...", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = imageSelector.image
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateStyle = DateFormatter.Style.long
        let currentDate = dateFormatter.string(from: date)
        
        procedure = Procedure(n: name, r: photo, d: currentDate, m: designator!, p1: [CGPoint](), i1: "0,0", s1: 0.0, s2: 0, s3: "", c1: 0.0, p2: "", p3: 0.0, r1: 0, a1: 0.0)
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //The info dictionary may contain multiple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        //Set Photo Image to display the selected image view
        imageSelector.image = selectedImage
        radiographImage = selectedImage
        procedure?.radiograph = selectedImage
        
        chosePicture = true
        dismiss(animated: true, completion: nil)
    }


    /*//MARK: Private Methods
    private func updateNextButtonState() {
        let text = nameTextField.text ?? ""
        
        if text == "Enter title here" {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }*/
}
