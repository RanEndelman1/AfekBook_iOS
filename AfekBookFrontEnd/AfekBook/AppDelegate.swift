//
//  AppDelegate.swift
//  AfekBook
//
//  Created by Ran Endelman on 14/10/2017.
//  Copyright © 2017 Ran Endelman. All rights reserved.
//

import UIKit

// global variable refered to appDelegate to be able to call it from any class / file.swift
let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

// colors
let colorSmoothRed = UIColor(red: 255 / 255, green: 50 / 255, blue: 75 / 255, alpha: 1)
let colorLightGreen = UIColor(red: 30 / 255, green: 244 / 255, blue: 125 / 255, alpha: 1)
let colorSmoothGray = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
let colorBrandBlue = UIColor(red: 45 / 255, green: 213 / 255, blue: 255 / 255, alpha: 1)

// sizes
let fontSize12 = UIScreen.main.bounds.width / 31

// stores all information about current user
var user: NSDictionary?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // boolean to check is erroView is currently showing or not
    var infoViewIsShowing = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//      Check if user is logged in
        user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
        print(user)
        if user != nil {
            let id = user!["id"] as? String
            if id != nil {
                login()
            }
        }
        return true
    }

//    Function to pass to home page or top bar
    func login() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBar")
        window?.rootViewController = tabBar
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func infoView(message:String, color:UIColor) {

        // if infoView is not showing ...
        if infoViewIsShowing == false {

            // cast as infoView is currently showing
            infoViewIsShowing = true


            // infoView - red background
            let infoView_Height = self.window!.bounds.height / 14.2
            let infoView_Y = 0 - infoView_Height

            let infoView = UIView(frame: CGRect(x: 0, y: infoView_Y, width: self.window!.bounds.width, height: infoView_Height))
            infoView.backgroundColor = color
            self.window!.addSubview(infoView)


            // infoView - label to show info text
            let infoLabel_Width = infoView.bounds.width
            let infoLabel_Height = infoView.bounds.height + UIApplication.shared.statusBarFrame.height / 2

            let infoLabel = UILabel()
            infoLabel.frame.size.width = infoLabel_Width
            infoLabel.frame.size.height = infoLabel_Height
            infoLabel.numberOfLines = 0

            infoLabel.text = message
            infoLabel.font = UIFont(name: "HelveticaNeue", size: fontSize12)
            infoLabel.textColor = .white
            infoLabel.textAlignment = .center

            infoView.addSubview(infoLabel)


            // animate info view
            UIView.animate(withDuration: 0.2, animations: {

                // move down infoView
                infoView.frame.origin.y = 0

                // if animation did finish
            }, completion: { (finished:Bool) in

                // if it is true
                if finished {

                    UIView.animate(withDuration: 0.1, delay: 3, options: .curveLinear, animations: {

                        // move up infoView
                        infoView.frame.origin.y = infoView_Y

                        // if finished all animations
                    }, completion: { (finished:Bool) in

                        if finished {
                            infoView.removeFromSuperview()
                            infoLabel.removeFromSuperview()
                            self.infoViewIsShowing = false
                        }

                    })

                }

            })


        }

    }

    func application(application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        let windows = UIApplication.shared.windows

        for window in windows {
            window.removeConstraints(window.constraints)
        }
    }
}

