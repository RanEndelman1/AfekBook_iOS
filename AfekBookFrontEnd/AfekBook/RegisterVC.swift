//
//  ViewController.swift
//  AfekBook
//
//  Created by Ran Endelman on 14/10/2017.
//  Copyright © 2017 Ran Endelman. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet var userNameTxt: UITextField!

    @IBOutlet var passwordTxt: UITextField!

    @IBOutlet var emailTxt: UITextField!

    @IBOutlet var firstNameTxt: UITextField!

    @IBOutlet var lastNameTxt: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }

    @IBAction func registerButton(_ sender: Any) {
        if userNameTxt.text!.isEmpty {
            userNameTxt.attributedPlaceholder = NSAttributedString(string: "Mandatory Field", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        } else if passwordTxt.text!.isEmpty {
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "Mandatory Field", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        } else if emailTxt.text!.isEmpty {
            emailTxt.attributedPlaceholder = NSAttributedString(string: "Mandatory Field", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        } else if firstNameTxt.text!.isEmpty {
            firstNameTxt.attributedPlaceholder = NSAttributedString(string: "Mandatory Field", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        } else if lastNameTxt.text!.isEmpty {
            lastNameTxt.attributedPlaceholder = NSAttributedString(string: "Mandatory Field", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        } else {
            /* Create new user in DB */

            /* URL to php file */
            let url = URL(string: "http://localhost/AfekBook/AfekBookBackEnd/register.php")!
            /* A request to this file */
            var request = URLRequest(url: url)
            /* Method to pass data to thos file */
            request.httpMethod = "POST"
            /* Body to be appended to url */
            let body = "username=\(userNameTxt.text!.lowercased())&password=\(passwordTxt.text!)" +
                    "&email=\(emailTxt.text!)&fullname=\(firstNameTxt.text!)%20\(lastNameTxt.text!)"
            /* Launch the request */
            request.httpBody = body.data(using: .utf8)
            URLSession.shared.dataTask(with: request) { data, response, error in

                if error == nil {

                    // get main queue in code process to communicate back to UI
                    DispatchQueue.main.async(execute: {

                        do {
                            // get json result
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]
                            // assign json to new var parseJSON in guard/secured way
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }
                            print(parseJSON)

                            // get id from parseJSON dictionary
                            let id = parseJSON["id"]

                            // successfully registered
                            if id != nil {

//                                Save user info
                                UserDefaults.standard.setValue(parseJSON, forKey: "parseJSON")
                                user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary

                                DispatchQueue.main.async(execute: {
//                                    Go to home page
                                    appDelegate.login()

                                })

                                // error
                            } else {

                                // get main queue to communicate back to user
                                DispatchQueue.main.async(execute: {
                                    let message = parseJSON["message"] as! String
//                                    appDelegate.infoView(message: message, color: colorSmoothRed)
                                })
                                return

                            }


                        } catch {

                            // get main queue to communicate back to user
                            DispatchQueue.main.async(execute: {
                                let message = "\(error)"
//                                appDelegate.infoView(message: message, color: colorSmoothRed)
                            })
                            return

                        }

                    })

                    // if unable to proceed request
                } else {

                    // get main queue to communicate back to user
                    DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
//                        appDelegate.infoView(message: message, color: colorSmoothRed)
                    })
                    return

                }

                // launch prepared session
            }.resume()
        }
    }
    
    
    // touched screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // hide keyboard
        self.view.endEditing(false)
    }
    

    @IBAction func alreadyHaveAccountButton(_ sender: Any) {
    }


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

