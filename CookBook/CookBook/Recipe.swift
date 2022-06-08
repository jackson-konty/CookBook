
import Foundation
import UIKit
class Recipe: NSObject, NSCoding{

    
    var name: String
    var image: UIImage?
    var creator: String
    var ingredients: String
    var instructions: String
    var time: Int
    var calories: Int
    var date_added: Date
    init(name:String, creator:String, ingredients:String,instructions:String,time:Int,calories: Int, image: UIImage? = nil){
        self.name = name
        self.creator = creator
        self.time = time
        self.instructions = instructions 
        self.ingredients = ingredients
        self.calories = calories
        if(image == nil){
            self.image = UIImage(named: "icon")
        }
        else{
            self.image = image
        }
        date_added = Date()
    }
    func getHours()->Int{
        return (time - time%60)/60
    }
    func getMinutes()->Int{
        return time%60
    }
    func edit(name:String, ingredients:String,instructions:String,time:Int,calories: Int){
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.time = time
        self.calories = calories
    }
    func toString()->String{
        return self.ingredients+"\n"+self.instructions
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(creator, forKey: "creator")
        coder.encode(ingredients, forKey: "ingredients")
        coder.encode(instructions, forKey: "instructions")
        coder.encode(time, forKey: "time")
        coder.encode(calories, forKey: "calories")
        coder.encode(date_added, forKey: "date_added")
        if let imageData = image?.pngData(){
            coder.encode(imageData, forKey: "image")
        }
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        creator = coder.decodeObject(forKey: "creator") as? String ?? ""
        ingredients = coder.decodeObject(forKey: "ingredients") as? String ?? ""
        instructions = coder.decodeObject(forKey: "instructions") as? String ?? ""
        time = coder.decodeInteger(forKey: "time")
        calories = coder.decodeInteger(forKey: "calories")
        date_added = coder.decodeObject(forKey: "date_added") as? Date ?? Date()
        let imageData = coder.decodeObject(forKey: "image") as? Data
        if let data = imageData{
            self.image = UIImage(data: data)
        }
        
    }
}
