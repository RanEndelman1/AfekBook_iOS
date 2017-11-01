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
    @IBAction func login_click(_ sender: Any) {
        //If no text entertd
       print("clicked")
       if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            //red placeholder
            usernameTxt.attributedPlaceholder = NSAttributedString(string:"username" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            passwordTxt.attributedPlaceholder = NSAttributedString(string:"password" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        
        } else {
        print("values enterd")
        let username = usernameTxt.text!.lowercased()
        let password = passwordTxt.text!
        
        
        let url = URL(string:"http://localhost/afekbook_ios/afekbookbackend/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = "username=\(username)&password=\(password)"
        
        print(body)
        
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if error == nil {
                
                DispatchQueue.main.async(execute: {

                do {
                    print("no error")
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]

                    guard let parseJSON = json else{
                        print("Error while parsing")
                        return
                    }
                    
                    print(parseJSON)
                    print("Hello")
                    
                    //remove keyboard
                    
                    let id = parseJSON["id"] as? String
                    
                    if id != nil {
                        // successfully log in
                     /*
                        //save user information we recived from our host
                       UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                        user = userDefaults.standard.valueForKey("pasreJSON") as? NSDictionary
                        
                        DispatchQueue.main.async (execute: {
                            //
                        })*/
                        
                    }
                    /*else{
                       DispatchQueue.main.async(execute: {
                            let message = parseJSON["message"] as! String
                            // appDelegate.infoView(message: message, color: colorSmoothRed)
                        })
                        return
                    }*/
                    
                }catch {
                    /*
                    // get main queue to communicate back to user
                    DispatchQueue.main.async(execute: {
                        let message = "\(error)"
                        // appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    return*/
                    }
                    
                })
                
            } else {
                /*
                // get main queue to communicate back to user
                DispatchQueue.main.async(execute: {
                    let message = error!.localizedDescription
                    //                        appDelegate.infoView(message: message, color: colorSmoothRed)
                })
                return*/

                }
          }.resume()
        }
    }
    
  /*  override func touchesBegan(touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
        <#code#>
    }*/
    
}
