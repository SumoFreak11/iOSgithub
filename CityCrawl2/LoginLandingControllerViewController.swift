//
//  LoginLandingControllerViewController.swift
//  CityCrawl2
//
//  Created by Arthur Bahr on 8/19/16.
//  Copyright © 2016 TurnupSF. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class LoginLandingControllerViewController: UIViewController {

    
    @IBOutlet weak var newUsername: UITextField!
    @IBAction func submitNewUsername(sender: AnyObject) {
        if (newUsername.text!.isEmpty) {
            let myAlert = UIAlertController(title:"Alert",
                message:"Please select a username",
                preferredStyle:UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            return

        }else {
            if let user = FIRAuth.auth()?.currentUser {
                for profile in user.providerData {
                    let name = profile.displayName
                    print("success")
                }
            } else {
               print("random error")
            }
        self.switchToNaVViewController()
        }

        }
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func switchToNaVViewController() {
        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // From main storyboard -> navigation controller
        let naviVC = storyboard.instantiateViewControllerWithIdentifier("HomeNavi") as! UINavigationController
        // Get the app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Set navigation controller as root controller
        appDelegate.window?.rootViewController = naviVC
    }
}
