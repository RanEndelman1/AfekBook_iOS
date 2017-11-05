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

    @IBOutlet var feedbackLbl: UILabel!
    @IBOutlet var passwordTxt: UITextField!

    //First func
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        feedbackLbl.text = ""

    }

    //Click login
    @IBAction func login_click(_ sender: Any) {
        //If no text entertd
        print("Login button clicked")
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            //red placeholder
            usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])

            passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])

        } else {
            // remove keyboard
            self.view.endEditing(true)

            // shortcuts
            let username = usernameTxt.text!.lowercased()
            let password = passwordTxt.text!

            // send request to mysql db
            // url to access our php file
            let url = URL(string: "http://localhost/AfekBook/AfekBookBackEnd/login.php")!

            // request url
            var request = URLRequest(url: url)

            // method to pass data POST - cause it is secured
            request.httpMethod = "POST"

            // body gonna be appended to url
            let body = "username=\(username)&password=\(password)"

            // append body to our request that gonna be sent
            request.httpBody = body.data(using: .utf8)

            URLSession.shared.dataTask(with: request) { data, response, error in

                if error == nil {

                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }

                        let id = parseJSON["id"] as? String
                        // successfully logged in
                        if id != nil {

                            // save user information we received from our host
                            UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary

                            // go to tabbar / home page
                            DispatchQueue.main.async(execute: {
                                appDelegate.login()
                            })

                            // error
                        } else {

                            // get main queue to communicate back to user
                            DispatchQueue.main.async(execute: {
                                let message = parseJSON["message"] as! String
//                                appDelegate.infoView(message: message, color: colorSmoothRed)
                                self.feedbackLbl.text = "Wrong User Name or Password, Try again."
                            })
                            return

                        }

                    } catch {

                        // get main queue to communicate back to user
                        DispatchQueue.main.async(execute: {
                            let message = "\(error)"
                            print(error)
//                            appDelegate.infoView(message: message, color: colorSmoothRed)
                            self.feedbackLbl.text = "Wrong User Name or Password, Try again."
                        })
                        return

                    }

                } else {

                    // get main queue to communicate back to user
                    DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    return

                }

            }.resume()
        }
    }
    
    // touched screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // hide keyboard
        self.view.endEditing(false)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
