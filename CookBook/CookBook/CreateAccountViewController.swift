//
//  CreateAccountViewController.swift
//  CookBook
//
//  Created by Konty, Jackson Halleck on 6/8/22.
//

import Foundation
import UIKit
class CreateAccountViewController: UIViewController{
    var delegate: AppDelegate?
    var sessionModel: UserSessionModel?
    override func viewDidLoad(){
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        sessionModel = delegate?.sessionModel
        
    }
    
}
