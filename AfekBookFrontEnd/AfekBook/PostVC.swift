//
//  PostVC.swift
//  AfekBook
//
//  Created by Ophir Karako on 04/11/2017.
//  Copyright © 2017 Ran Endelman. All rights reserved.
//

import UIKit

class PostVC: UIViewController, UITextViewDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //UI obj
    @IBOutlet var textTxt: UITextView!
    @IBOutlet var countLbl: UILabel!
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var pictureImg: UIImageView!
    
    @IBOutlet var postBtn: UIButton!
    
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
        self.present(picker, animated: true, completion: nil)
    }
    
    // selected image in picker view
    @objc  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pictureImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
  
    @IBAction func post_click(_ sender: Any) {
        // if entered some text and text is less than 140 chars
        if !textTxt.text.isEmpty && textTxt.text.characters.count <= 140 {
            
            // call func to uplaod post
        // uploadPost()
            
        }
    }
    

}
