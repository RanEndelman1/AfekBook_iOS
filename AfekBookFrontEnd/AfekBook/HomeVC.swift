//
//  HomeVC.swift
//  AfekBook
//
//  Created by Ophir Karako on 04/11/2017.
//  Copyright © 2017 Ran Endelman. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet var avaImg: UIImageView!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var fullnameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // get user details from user global var
        // shortcuts to store inf
        let username = (user!["username"] as AnyObject).uppercased
        let fullname = user!["fullname"] as? String
        let email = user!["email"] as? String
        let ava = user!["ava"] as? String
        
        // assign values to labels
        usernameLbl.text = username
        fullnameLbl.text = fullname
        emailLbl.text = email
        

        // Do any additional setup after loading the view.
    }

    @IBAction func edit_click(_ sender: Any) {
    }
    
    
    @IBAction func logout_click(_ sender: Any) {
        
        // remove saved information
        UserDefaults.standard.removeObject(forKey: "parseJSON")
        UserDefaults.standard.synchronize()
        
        // go to login page
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginVC, animated: true, completion: nil)
    }
    
}
