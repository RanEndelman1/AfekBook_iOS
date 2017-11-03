//
//  NavVC.swift
//  AfekBook
//
//  Created by Ran Endelman on 04/11/2017.
//  Copyright © 2017 Ran Endelman. All rights reserved.
//

import UIKit

class NavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // color of title at the top of nav controller
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        // color of buttons in nav controller
        self.navigationBar.tintColor = .white

        // color of background of nav controller / nav bar
        self.navigationBar.barTintColor = colorBrandBlue

        // disable translucent
        self.navigationBar.isTranslucent = false
    }

    // white status bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
