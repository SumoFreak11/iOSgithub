//
//  SignUpViewController.swift
//  CityCrawl2
//
//  Created by Arthur Bahr on 7/25/16.
//  Copyright © 2016 TurnupSF. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit

class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loginButton)
        loginButton.center = CGPointMake(375.0/2, 480.0)
        
        self.loginButton.readPermissions = ["email", "public_profile"]
        self.loginButton.delegate = self
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            self.fetchProfile()
            self.switchToFirstTVC()
        }
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection,
            result, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            if let email = result["email"] as? String {
                print(email)
            }
            if let name = result["first_name"] as? String {
                print(name)
            }
            if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary,
            url = data["url"] as? String {
                print(url)
            }
    }
}
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result:
        FBSDKLoginManagerLoginResult!, error: NSError!) {
            
            if(error != nil) {
                print(error!.localizedDescription)
                return
            }else if(result.isCancelled) {
                // handle the cancel event (person hit cancel in facebook page)
            }else {
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
             FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                }
            }
            if let token = FBSDKAccessToken.currentAccessToken() {
            self.fetchProfile()
            self.switchToFirstTVC()
            }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print ("user logged out")
    }
    
    // Login using Facebook button
    @IBAction func facebookLoginDidTapped(sender: AnyObject) {
        
    }
    
    private func switchToNaVViewController() {
        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // From main storyboard -> navigation controller
        let naviVC = storyboard.instantiateViewControllerWithIdentifier("NavigationVC") as! UINavigationController
        // Get the app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Set navigation controller as root controller
        appDelegate.window?.rootViewController = naviVC
}

    private func switchToFirstTVC() {
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