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
            let body = "username=\(userNameTxt.text!.lowercased())&password=\(passwordTxt.text!.lowercased())&email=\(emailTxt.text!.lowercased())" +
                    "&fullname=\(firstNameTxt.text!.lowercased())%20\(lastNameTxt.text!.lowercased())"
            /* Launch the request */
            request.httpBody = body.data(using: String.Encoding.utf8)
            URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?,
                                                                         error: Error?) in
                if error == nil {
                    DispatchQueue.main.async {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }
                            let id = parseJSON["id"]
                            if id != nil {
                                print(parseJSON)
                            }

                        } catch {
                            print("Caught an error:\(error)")
                        }
                    }
                } else {
                    print("error: \(error)")
                }
            }).resume()
        }
    }

    @IBAction func alreadyHaveAccountButton(_ sender: Any) {
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

