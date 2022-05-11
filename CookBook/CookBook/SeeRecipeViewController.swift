//
//  SeeRecipeViewController.swift
//  CookBook
//
//  Created by Meera Iyer on 4/16/22.
//

import UIKit
import MessageUI

class SeeRecipeViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var oldRecipeName: UITextView!
    @IBOutlet weak var oldHours: UITextView!
    @IBOutlet weak var oldMinutes: UITextView!
    @IBOutlet weak var oldDirections: UITextView!
    @IBOutlet weak var oldIngredients: UITextView!
    @IBOutlet weak var oldCalories: UITextView!
    var editMode = false
    var delegate: AppDelegate?
    var sessionModel: UserSessionModel?
    var recipeIndex = 0
    
    
    @IBAction func removeRecipe(_ sender: Any) {
        delegate = UIApplication.shared.delegate as? AppDelegate
        sessionModel = delegate?.sessionModel
        if let myRecipeModel = self.sessionModel{
            myRecipeModel.removeRecipe(index: recipeIndex)
        }
        if let navController = self.navigationController {
            if let viewController = navController.topViewController as? UITableViewController{
                viewController.tableView.reloadData()
            }
        }
        self.dismiss(animated: true)
    }
    
    
    @IBAction func editRecipe(_ sender: Any) {
        if(!editMode){
            if let sendButton = self.sendButton{
                sendButton.isHidden = true
                sendButton.isEnabled = false
            }
            if let deleteButton = self.deleteButton{
                deleteButton.isHidden = true
                deleteButton.isEnabled = false
            }
            if let editButton = self.editButton{
                editButton.setTitle("Save", for: .normal)
            }
            if let oldRecipeName = self.oldRecipeName{
                oldRecipeName.isEditable = true
            }
            if let oldHours = self.oldHours{
                oldHours.isEditable = true
            }
            if let oldMinutes = self.oldMinutes{
                oldMinutes.isEditable = true
            }
            if let oldDirections = self.oldDirections{
                oldDirections.isEditable = true
            }
            if let oldIngredients = self.oldIngredients{
                oldIngredients.isEditable = true
            }
            if let oldCalories = self.oldCalories{
                oldCalories.isEditable = true
            }
            self.editMode = true
        }
        else{
            
            if let sendButton = self.sendButton{
                sendButton.isHidden = false
                sendButton.isEnabled = true
            }
            if let deleteButton = self.deleteButton{
                deleteButton.isHidden = false
                deleteButton.isEnabled = true
            }
            if let editButton = self.editButton{
                editButton.setTitle("Edit", for: .normal)
            }
            if let oldRecipeName = self.oldRecipeName{
                oldRecipeName.isEditable = false
                if let oldHours = self.oldHours{
                    oldHours.isEditable = false
                    if let oldMinutes = self.oldMinutes{
                        oldMinutes.isEditable = false
                        if let oldDirections = self.oldDirections{
                            oldDirections.isEditable = false
                            if let oldIngredients = self.oldIngredients{
                                oldIngredients.isEditable = false
                                if let oldCalories = self.oldCalories{
                                    oldCalories.isEditable = false
                                    delegate = UIApplication.shared.delegate as? AppDelegate
                                    sessionModel = delegate?.sessionModel
                                    if let myRecipeModel = self.sessionModel{
                                        let minutes = Int(oldMinutes.text) ?? 0
                                        let hours  = Int(oldHours.text) ?? 0
                                        let calories = Int(oldCalories.text) ?? 0
                                        let time = (hours*60)+minutes
                                        myRecipeModel.editRecipe(index: recipeIndex, name: oldRecipeName.text, ingredients: oldIngredients.text, instructions: oldDirections.text, time: time, calories: calories)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.editMode = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        sessionModel = delegate?.sessionModel
        if let sessionModel = self.sessionModel{
            let recipe = sessionModel.getRecipe(index: recipeIndex)
            oldRecipeName.text = recipe.name
            oldHours.text = "\(recipe.getHours())"
            oldMinutes.text = "\(recipe.getMinutes())"
            oldDirections.text = recipe.instructions
            oldIngredients.text = recipe.ingredients
            oldCalories.text = "\(recipe.calories)"
        }
        self.oldHours.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.oldMinutes.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.oldRecipeName.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.oldDirections.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.oldIngredients.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.oldCalories.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
}

@IBDesignable class UITextViewModified: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.init(top: 1, left: 2, bottom: 0, right: 0)
        textContainer.lineFragmentPadding = 0
    }
}


extension SeeRecipeViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch (result) {
            case .cancelled:
                print("Message was cancelled")
                dismiss(animated: true, completion: nil)
            case .failed:
                print("Message failed")
                dismiss(animated: true, completion: nil)
            case .sent:
                print("Message Sent!")
                dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    
    @IBAction func sendMessage(_ sender: Any) {
        let messageVC = MFMessageComposeViewController()
        messageVC.messageComposeDelegate = self
        messageVC.body = "Check out this new recipe!\n"
        messageVC.recipients = ["New Message"]
        if MFMessageComposeViewController.canSendText() {
                    self.present(messageVC, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: nil, message: "Could not access iMessage", preferredStyle: .alert)

                    let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (alert: UIAlertAction!) in
                    })

                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}

