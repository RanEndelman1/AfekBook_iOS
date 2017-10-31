//
//  LoginVC.swift
//  AfekBook
//
//  Created by Ophir Karako on 31/10/2017.
//  Copyright © 2017 Ran Endelman. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    //UI obj
  
    @IBOutlet var usernameTxt: UITextField!
    
    @IBOutlet var passwordTxt: UITextField!
    
    //First func
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

    }
    //Click login
    @IBAction func login_click(_ sender: AnyObject) {
        //If no text entertd
        
       if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            //red placeholder
            usernameTxt.attributedPlaceholder = NSAttributedString(string:"username" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            passwordTxt.attributedPlaceholder = NSAttributedString(string:"password" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        
        } else {
            //send req to mysql
            
            
        }
    }
    
}
