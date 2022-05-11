//
//  ViewController.swift
//  CookBook
//
//  Created by Konty, Jackson Halleck on 4/13/22.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController, UITextFieldDelegate,UICollectionViewDelegate, UICollectionViewDataSource{
    
    var delegate: AppDelegate?
    var sessionModel: UserSessionModel?
    
    @IBOutlet weak var recentCells: UICollectionView!
    @IBOutlet weak var featuredCells: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate = UIApplication.shared.delegate as? AppDelegate
        sessionModel = delegate?.sessionModel
        
        if (collectionView == featuredCells){
            if let recipeCount = sessionModel{
                let num = recipeCount.getRecipes().count
                if (num > 3){
                    return 3
                }
                return num
            }
        }
        
        if (collectionView == recentCells){
            if let recipeCount = sessionModel{
                let num = recipeCount.getRecipes().count
                if (num > 3){
                    return 3
                }
                return num
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        delegate = UIApplication.shared.delegate as? AppDelegate
        sessionModel = delegate?.sessionModel
        //let recipeReverse = [Recipe](recipes.reversed())
        let cell = recentCells.dequeueReusableCell(withReuseIdentifier: "rCell", for: indexPath) as! RecentCollectionViewCell
        
        if let recipeModel = sessionModel{
            let recipeList = recipeModel.getRecipes()
            let reverseList = [Recipe](recipeList.reversed())
            let label = reverseList[indexPath.row]
            cell.recentName.text = label.name
            cell.recentImage.image = label.image
            print(label.name)
        }
         
        //let recipe = recipeReverse[indexPath.row]
         
        //cell.recentName.text = label.name
        //cell.recentImage.image = UIImage(named: "Apple")
        cell.backgroundColor = UIColor.systemGray2
        

        if (collectionView == featuredCells){
            let cell2 = featuredCells.dequeueReusableCell(withReuseIdentifier: "fCell", for: indexPath) as! FeaturedCollectionViewCell
        
            
            if let recipeModel = sessionModel{
                var randRecipes: [Recipe] = []
                let text = recipeModel.getRecipes()
                
                for i in 0...recipeModel.getRecipes().count{
                    if (i == 3){
                        break
                    }
                    randRecipes.append(text.randomElement()!)
                }
                print(text.description)
                let label = randRecipes[indexPath.row]
                cell2.featureName.text = label.name
                cell2.featureImage.image = label.image
            }
             
            /*
            let recipe = recipes[indexPath.row]
            cell2.featureName.text = recipe.name
            */
            //cell2.featureImage.image = UIImage(named: "Apple")
            cell2.backgroundColor = UIColor.black
            return cell2
        }
         
        return cell
    }
    
    // 
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         // perform a segue to the destination controller you want
         // in prepare(for segue), set the parameters you need in destination controller
        
        if (collectionView == featuredCells){
            performSegue(withIdentifier: "fSeg", sender:self)
        }
            
        performSegue(withIdentifier: "rSeg", sender:self)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let seeRecipeViewController = (segue.destination as? SeeRecipeViewController) ,let selectedRow = collectionView.indexPathsForSelectedItems?.first() {
            seeRecipeViewController.selectedRow = sessionModel[index.row]
        
            
        }
        
        
        
        
    }
     */
    
    @objc func allowNotifs() {
        let center = UNUserNotificationCenter.current()

            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    print("Accepted")
                } else {
                    print("Rejected")
                }
            }

    }

    @objc func sendNotifs() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "NEW RECIPE ALERT"
        content.body = "Checkout some new featured recipes!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        // Use this for testing
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        // Use this for daily notifs
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        print("SENT")

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        self.sessionModel = delegate?.sessionModel
        if let sessionModel = self.sessionModel{
            sessionModel.setHome(homeController: self)
        }
        
        self.allowNotifs()
        self.sendNotifs()
        
        
    }
}

