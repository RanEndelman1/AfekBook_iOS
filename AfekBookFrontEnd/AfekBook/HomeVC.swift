//
//  HomeVC.swift
//  AfekBook
//
//  Created by Ophir Karako on 04/11/2017.
//  Copyright © 2017 Ran Endelman. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var avaImg: UIImageView!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var fullnameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var tableView: UITableView!


    var posts = [AnyObject]()
    var images = [UIImage]()

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
        tableView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0)
        // Do any additional setup after loading the view.
//        posts = ["posts", "posts", "posts", "posts"]
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        let username = post["username"] as? String
        let text = post["text"] as? String
        let date = post["date"] as! String

        // converting date string to date
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let newDate = dateFormater.date(from: date)!

        // declare settings
        let from = newDate
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from, to: now, options: [])

        // calculate date
        if difference.second! <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLbl.text = "\(difference.second)".digits + "s."
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLbl.text = "\(difference.minute)".digits + "m."
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLbl.text = "\(difference.hour)".digits + "h."
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLbl.text = "\(difference.day)".digits + "d."
        }
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth)".digits + "w."
        }
        print(cell.dateLbl.text)
        cell.userNameLbl.text = username
        cell.textLbl.text = text


        DispatchQueue.main.async(execute: {
            cell.textLbl.sizeToFit()
        })

        cell.pictureImg.image = UIImage(named: "ava.jpg")
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // call func of loading posts
        loadPosts()
    }

    func loadPosts() {

        // shortcut to id
        let id = user!["id"] as! String

        // accessing php file via url path
        let url = URL(string: "http://localhost/AfekBook/AfekBookBackEnd/posts.php")!

        // declare request to proceed php file
        var request = URLRequest(url: url)

        // declare method of passing information to php file
        request.httpMethod = "POST"

        // pass information to php file
        let body = "id=\(id)&text=&uuid="
        request.httpBody = body.data(using: String.Encoding.utf8)

        // launch session
        URLSession.shared.dataTask(with: request) { data, response, error in

            // get main queue to operations inside of this block
            DispatchQueue.main.async(execute: {

                // no error of accessing php file
                if error == nil {

                    do {

                        // getting content of $returnArray variable of php file
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                        // clean up
                        self.posts.removeAll(keepingCapacity: false)
                        self.images.removeAll(keepingCapacity: false)
                        self.tableView.reloadData()

                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        // declare new posts to store parseJSON
                        guard let userPosts = parseJSON["posts"] as? [AnyObject] else {
                            print("Error while parseJSON")
                            return
                        }
                        // append all posts var's inf to posts
                        self.posts = userPosts
                        // getting images from url paths
                        for i in 0..<self.posts.count {

                            // path we are getting from $returnArray that assigned to parseJSON > to posts > posts
                            let path = self.posts[i]["path"] as? String

                            // if we found path
                            if !path!.isEmpty {
                                let url = URL(string: path!)! // convert path str to url
                                let imageData = try? Data(contentsOf: url) // get data via url and assigned imageData
                                let image = UIImage(data: imageData!)! // get image via data imageData
                                self.images.append(image) // append found image to [images] var
                            } else {
                                let image = UIImage() // if no path found, create a gab of type uiimage
                                self.images.append(image) // append gap to uiimage to avoid crash
                            }

                        }
                        // reload tableView to show back information
                        self.tableView.reloadData()


                    } catch {
                    }

                } else {
                }

            })

        }.resume()

    }

}

extension String {

    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
    }
}
