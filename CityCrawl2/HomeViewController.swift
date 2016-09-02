//
//  HomeViewController.swift
//  CityCrawl2
//
//  Created by Arthur Bahr on 8/19/16.
//  Copyright © 2016 TurnupSF. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FBSDKCoreKit

class HomeViewController: UIViewController {
    
    
    @IBAction func upcomingEventTapped(sender: AnyObject) {
        self.switchToNaVViewController()

    }
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        // logout of firebase
        try! FIRAuth.auth()!.signOut()
        // logout of facebook
        print ("user logged out")
        FBSDKAccessToken.setCurrentAccessToken(nil)
        // navigate back home to login screen
        returnHomeAfterLogout()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func switchToNaVViewController() {
        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // From main storyboard -> navigation controller
        let naviVC = storyboard.instantiateViewControllerWithIdentifier("ChatNavi") as! UINavigationController
        // Get the app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Set navigation controller as root controller
        appDelegate.window?.rootViewController = naviVC
    }
    
    private func returnHomeAfterLogout() {
        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // From main storyboard -> navigation controller
        let naviVC = storyboard.instantiateInitialViewController()
        // Get the app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Set navigation controller as root controller
        appDelegate.window?.rootViewController = naviVC
    }


}
