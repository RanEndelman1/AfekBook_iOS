//
//  PostVC.swift
//  AfekBook
//
//  Created by Ophir Karako on 04/11/2017.
//  Copyright © 2017 Ran Endelman. All rights reserved.
//

import UIKit

class PostVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //UI obj
    @IBOutlet var textTxt: UITextView!
    @IBOutlet var countLbl: UILabel!
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var pictureImg: UIImageView!
    @IBOutlet var postBtn: UIButton!

//    Post's unique ID
    var uuid = String()
    var imageSelected = false


    override func viewDidLoad() {
        super.viewDidLoad()

        // round corners
        textTxt.layer.cornerRadius = textTxt.bounds.width / 50
        postBtn.layer.cornerRadius = postBtn.bounds.width / 20

        // colors
        selectBtn.setTitleColor(colorBrandBlue, for: UIControlState())
        postBtn.backgroundColor = colorBrandBlue
        countLbl.textColor = colorSmoothGray

        // disable auto scroll layout
        self.automaticallyAdjustsScrollViewInsets = false

        // disable button from the begining
        postBtn.isEnabled = false
        postBtn.alpha = 0.4

        // disable button from the begining
        postBtn.isEnabled = false
        postBtn.alpha = 0.4

    }

    // entered some text in TextView
    func textViewDidChange(_ textView: UITextView) {

        // numb of characters in textView
        let chars = textView.text.characters.count

        // white spacing in text
        let spacing = CharacterSet.whitespacesAndNewlines

        // calculate string's length and convert to String
        countLbl.text = String(140 - chars)

        // if number of chars more than 140
        if chars > 140 {
            countLbl.textColor = colorSmoothRed
            postBtn.isEnabled = false
            postBtn.alpha = 0.4

            // if entered only spaces and new lines
        } else if textView.text.trimmingCharacters(in: spacing).isEmpty {
            postBtn.isEnabled = false
            postBtn.alpha = 0.4

            // everything is correct
        } else {
            countLbl.textColor = colorSmoothGray
            postBtn.isEnabled = true
            postBtn.alpha = 1
        }

    }

    // touched screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        // hide keyboard
        self.view.endEditing(false)
    }

    // clicked select picture button
    @IBAction func select_click(_ sender: Any) {

        // calling picker for selecting iamge
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        DispatchQueue.main.async(execute: {
            self.present(picker, animated: true, completion: nil)
        })
    }

    // selected image in picker view
    @objc  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        pictureImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true, completion: nil)
        })

//      flag for DB
        imageSelected = true
    }


    @IBAction func post_click(_ sender: Any) {
        // if entered some text and text is less than 140 chars
        if !textTxt.text.isEmpty && textTxt.text.characters.count <= 140 {

            // call func to uplaod post
            uploadPost()
            print("post uploaded")

        }
    }

    // custom body of HTTP request to upload image file
    func createBodyWithParams(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {

        var body = Data()

        if parameters != nil {
            for (key, value) in parameters! {
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }

        let filename = ""

        if imageSelected == true {
            let filename = "post-\(uuid).jpg"
        }

        let mimetype = "image/jpg"

        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
        body.append(imageDataKey)
        body.append(Data("\r\n".utf8))

        body.append(Data("--\(boundary)--\r\n".utf8))

        return body
    }

    func uploadPost() {
        let id = user!["id"] as! String
        let uuid = NSUUID().uuidString
        let text = textTxt.text as String
        let url = URL(string: "http://localhost/AfekBook/AfekBookBackEnd/posts.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let param = [
            "id": id,
            "uuid": uuid,
            "text": text
        ]
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var imageData = Data()
        if pictureImg.image != nil {
            imageData = UIImageJPEGRepresentation(pictureImg.image!, 0.5)!
        }

        request.httpBody = createBodyWithParams(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {

                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]
                    guard let parseJSON = json else {
                        print("Error while parsing")
                        return
                    }
                    print(parseJSON)

                    let message = parseJSON["message"] as? String
                    if message != nil {
                        DispatchQueue.main.async(execute: {
                            print("Successfully posted!")
                            self.textTxt.text = ""
                            self.pictureImg.image = UIImage()
                            self.postBtn.alpha = 0.4
                            self.postBtn.isEnabled = false
                            self.tabBarController?.selectedIndex = 0
                        })
                    }
                } catch {

                    // get main queue to communicate back to user
                    DispatchQueue.main.async(execute: {
                        let message = "\(error)"
                        print(error)
                        appDelegate.infoView(message: message, color: colorSmoothRed)

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
