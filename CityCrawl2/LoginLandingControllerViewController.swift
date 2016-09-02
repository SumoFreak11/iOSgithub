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
        let user = FIRAuth.auth()?.currentUser
            if let user = user {
            let changeRequest = user.profileChangeRequest()
            
            changeRequest.displayName = newUsername.text!
            changeRequest.commitChangesWithCompletion { error in
                // if let error = error {
                if error != nil {
                    // An error happened.
                } else {
                    print ("Updated")
                    print (self.newUsername.text!)
                    self.switchToNaVViewController()
                }}
            }
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
