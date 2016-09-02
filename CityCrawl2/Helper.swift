//
//  Helper.swift
//  CityCrawl2
//
//  Created by Arthur Bahr on 7/25/16.
//  Copyright © 2016 TurnupSF. All rights reserved.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase
import FBSDKLoginKit

/*
class Helper {
    static let helper = Helper()
    
    func loginWithFacebook() {
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.currentUser!.linkWithCredential(credential) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }else {
                self.switchToNaVViewController()
                
            }
        }             
    }

    func logInWithGoogle(authentication: GIDAuthentication) {
        func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let authentication = user.authentication
            let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                accessToken: authentication.accessToken)
            
            FIRAuth.auth()?.currentUser!.linkWithCredential(credential) { (user, error) in
                if error != nil {
                    let prevUser = FIRAuth.auth()?.currentUser
                    FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                        // ...
                    }
                    let currentUser = FIRAuth.auth()?.currentUser
                    // Merge prevUser and currentUser accounts and data
                    // ...
                    return self.switchToNaVViewController()
                }else {
                    self.switchToNaVViewController()
                    
                }
                
            }}
        
        func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
            withError error: NSError!) {
                // Perform any operations when the user disconnects from app here.
                // ...
                
        }
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
    
}
*/