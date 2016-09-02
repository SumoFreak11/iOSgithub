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
       
        // GIDSignIn.sharedInstance().uiDelegate = self
        // GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        // GIDSignIn.sharedInstance().signInSilently()
        // GIDSignIn.sharedInstance().delegate = self
        
        loginButton.hidden = true

        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // user is signed in
                // if whereever I save the username is != nil then take to next page else take to make username page
                self.switchToNaVViewController()
            }else {
                self.loginButton.readPermissions = ["email", "public_profile"]
                //self.loginButton.center = self.view.center
                self.loginButton.delegate = self
                //self.view.addSubview(self.loginButton)
                
                self.loginButton.hidden = false
            }}
            }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result:
        FBSDKLoginManagerLoginResult!, error: NSError!) {
            
            print("user logged in")
            
            if(error != nil) {
                print(error!.localizedDescription)
                return
            }else if(result.isCancelled) {
                // handle the cancel event
            }else {

            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
             FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                
            print("logged into firebase")
                }
            }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print ("user logged out")
    }
    
    
    
    
//    
//    {
//    "rules": {
//    ".read": "auth != true",
//    ".write": "auth != true"
//    }
//    }
    
    
    
    
    
    
    // Login using Facebook button
    @IBAction func facebookLoginDidTapped(sender: AnyObject) {
        
        
    }
   
//    Login using Google button
//    @IBAction func googleLoginDidTapped(sender: AnyObject) {
//        print("google login did tapped")
//        Helper.helper.logInWithGoogle()
//        
//        GIDSignIn.sharedInstance().signIn()
//        }
    
        
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

}
