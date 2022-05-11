//
//  UserSessionModel.swift
//  CookBook
//
//  Created by Konty, Jackson Halleck on 4/13/22.
//

import Foundation

class UserSessionModel {
    private var username: String
    private var recipes = [Recipe]()
    private var tableController: RecipesTableViewController!
    private var homeController: HomeViewController!
    private let defaults = UserDefaults.standard
    private var emptyRecipe = Recipe(name: "", creator: "", ingredients: "", instructions: "", time: 0, calories: 0)
    
    
    init(){
        self.username = NSUserName()
        tableController = nil
        if let savedRecipes = defaults.object(forKey: "recipes") as? Data {
            if let decodedRecipes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedRecipes) as? [Recipe] {
                self.recipes = decodedRecipes
            }
        }
        if(recipes.isEmpty){
            self.addRecipe(recipe: Recipe(name: "Eggs", creator: username, ingredients: "Two Eggs", instructions: "Cook until firm, stirring constantly", time: 15, calories: 140))
        }
    }
    func addRecipe(recipe:Recipe){
        self.recipes.append(recipe)
        self.refreshTables()
        self.save()
    }
    func removeRecipe(index: Int){
        if(index < self.recipes.endIndex){
            self.recipes.remove(at: index)
        }
        self.refreshTables()
        self.save()
    }
    func getRecipes()->[Recipe]{
        return self.recipes
    }
    func getRecipe(index: Int)->Recipe{
        if(index < self.recipes.endIndex){
            return self.recipes[index]
        }
        return self.emptyRecipe
    }
    func getName()->String{
        return self.username
    }
    func editRecipe(index: Int, name:String, ingredients:String,instructions:String,time:Int,calories: Int){
        if(index < self.recipes.endIndex){
            self.recipes[index].edit(name: name, ingredients: ingredients, instructions: instructions, time: time, calories: calories)
        }
        refreshTables()
        save()
    }
    func setName(newName: String){
        self.username = newName;
    }

    func setTable(tableController : RecipesTableViewController){
        self.tableController = tableController
    }
    func setHome(homeController: HomeViewController){
        self.homeController = homeController
    }
    
    
    private func refreshTables(){
        if(tableController != nil){
            if let table = tableController.tableView{
                table.reloadData()
            }
        }
        if(homeController != nil){
            if let collection = homeController.featuredCells{
                collection.reloadData()
            }
            if let collection = homeController.recentCells{
                collection.reloadData()
            }
        }
        
    }
    private func save(){
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: recipes, requiringSecureCoding: false) {
            self.defaults.set(savedData, forKey: "recipes")
        }
    }

}


