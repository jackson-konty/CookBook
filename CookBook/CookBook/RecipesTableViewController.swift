//
//  TableViewController.swift
//  CookBook
//
//  Created by Meera Iyer on 4/16/22.
//

import UIKit

class RecipesTableViewController: UITableViewController{
    var delegate: AppDelegate?
    var sessionModel: UserSessionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = UIApplication.shared.delegate as? AppDelegate
        self.sessionModel = self.delegate?.sessionModel
        if let sessionModel = self.sessionModel {
            sessionModel.setTable(tableController: self)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.delegate = UIApplication.shared.delegate as? AppDelegate
        self.sessionModel = self.delegate?.sessionModel
        if let sessionModel = self.sessionModel {
            return sessionModel.getRecipes().count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rCell", for: indexPath) as! CookBookTableViewCell
        let index = indexPath.row
        self.delegate = UIApplication.shared.delegate as? AppDelegate
        self.sessionModel = self.delegate?.sessionModel
        if let sessionModel = sessionModel {
            let recipe = sessionModel.getRecipe(index: index)
            cell.tableRecipe.text = recipe.name
            if(recipe.time == 1){
                cell.tableTime.text = "\(recipe.time) minute"
            }
            else{
                cell.tableTime.text = "\(recipe.time) minutes"
            }
            cell.tableCalories.text = "\(recipe.calories)"
            cell.recipeImageView.image = recipe.image
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let seeRecipeViewController = segue.destination as! SeeRecipeViewController
        let selectedRow = tableView.indexPathForSelectedRow!.row
    
        seeRecipeViewController.recipeIndex = selectedRow
    }
}
