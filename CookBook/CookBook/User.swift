//
//  User.swift
//  CookBook
//
//  Created by Konty, Jackson Halleck on 6/8/22.
//

import Foundation
class User: NSObject, NSCoding{
    var username: String
    var fname: String
    var lname: String
    init(username:String,fname:String,lname:String){
        self.username = username
        self.fname = fname
        self.lname = lname
    }
    func encode(with coder: NSCoder) {
        coder.encode(self.username, forKey: "username")
        coder.encode(self.fname, forKey: "fname")
        coder.encode(self.lname, forKey: "lname")
    }
    
    required init?(coder: NSCoder) {
        self.username = coder.decodeObject(forKey: "username") as? String ?? ""
        self.fname = coder.decodeObject(forKey: "fname") as? String ?? ""
        self.lname = coder.decodeObject(forKey: "lname") as? String ?? ""
    }
}
