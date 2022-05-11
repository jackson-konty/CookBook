//
//  AddRecipeViewController.swift
//  CookBook
//
//  Created by Meera Iyer on 4/16/22.
//

import UIKit

class AddRecipeViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate: AppDelegate?
    var sessionModel: UserSessionModel?
    var imageAdded = false
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeHours: UITextField!
    @IBOutlet weak var recipeMinutes: UITextField!
    @IBOutlet weak var recipeIngrediants: UITextView!
    @IBOutlet weak var recipeCalories: UITextField!
    @IBOutlet weak var recipeDirections: UITextView!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func addImageButton(_ sender: Any) {
        
        // adding the camera functionality as well.
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert,animated: true,completion: nil)
           
    }
    
    func openCamera(){
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (alert: UIAlertAction!) in
            })

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveRecipe(_ sender: Any) {
        delegate = UIApplication.shared.delegate as? AppDelegate
        sessionModel = delegate?.sessionModel
        if let sessionModel = self.sessionModel{
            let name = recipeName.text ?? ""
            let hourString = recipeHours.text ?? ""
            let minuteString = recipeMinutes.text ?? ""
            let ingredients = recipeIngrediants.text ?? ""
            let calorieString = recipeCalories.text ?? ""
            let directions = recipeDirections.text ?? ""
            let hours = Int(hourString) ?? 0
            let minutes = Int(minuteString) ?? 0
            let time = (hours*60)+minutes
            let calories = Int(calorieString) ?? 0
            if imageAdded{
                sessionModel.addRecipe(recipe: Recipe(name: name,creator: sessionModel.getName(),ingredients: ingredients,instructions: directions,time: time, calories: calories, image: imageView.image))
            }
            else{
                sessionModel.addRecipe(recipe: Recipe(name: name,creator: sessionModel.getName(),ingredients: ingredients,instructions: directions,time: time, calories: calories))
            }
        }
        self.dismiss(animated: true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeName.delegate = self
        self.recipeHours.delegate = self
        self.recipeMinutes.delegate = self
        self.recipeCalories.delegate = self
        imagePicker.delegate = self
        

        
        
        self.recipeIngrediants.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.recipeDirections.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))

        
        //let gesture = UITapGestureRecognizer(target: self, action: #selector(launchCamera(_:)))
        //imageView.isUserInteractionEnabled = true
        //imageView.addGestureRecognizer(gesture)
    }
    
    /*
    @objc private func launchCamera(_ imageView: UIImageView) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (alert: UIAlertAction!) in
            })

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let photoPicker = PhotoPicker(presentationViewController: self)
            photoPicker.presentCamera { image in
                switch imageView {
                    case self.imageView:
                        self.imageView.image = image
                        self.imageAdded = true
                    default:
                        return
                }
            }
        }

    }
    
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
     
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
     
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            imageAdded = true
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
}
