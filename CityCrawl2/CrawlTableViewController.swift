//
//  CrawlTableViewController.swift
//  CityCrawl2
//
//  Created by Arthur Bahr on 8/19/16.
//  Copyright © 2016 TurnupSF. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class CrawlTableViewController: UITableViewController {
    
    var databaseRef:FIRDatabaseReference!
    var events = [Event]()
    @IBOutlet weak var welcomeLabel: UILabel!
    let storage = FIRStorage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBSDKGraphRequest(graphPath: "me", parameters:["fields": "first_name"]).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            let name = user["first_name"] as? String
            print(name)
            self.welcomeLabel.text = "Welcome, \(name!)"
})
        
        databaseRef = FIRDatabase.database().reference().child("events")
        startObservingDB()
        print(FIRAuth.auth()?.currentUser?.uid)
        print(FIRAuth.auth()?.currentUser?.providerID)
        
    }
    
    @IBAction func logoutButtonTapped(sender: UIBarButtonItem) {
        // logout of firebase
        try! FIRAuth.auth()!.signOut()
        // logout of facebook
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        returnHomeAfterLogout()
    }
    
    func startObservingDB() {
        databaseRef.observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
            var newEvents = [Event]()
            for event in snapshot.children {
                let eventObject = Event(snapshot: event as! FIRDataSnapshot)
                newEvents.append(eventObject)
            }
            self.events = newEvents
            print(newEvents)
            self.tableView.reloadData()
            }) { (error:NSError) in
                print(error.description)
    }
        }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let EventDetails = self.storyboard!.instantiateViewControllerWithIdentifier("EventDetails") as! EventHomePage
        EventDetails.details = self.events[indexPath.row]

        let alert = UIAlertController(title: "Crawl Key", message: "Please enter your crawl key", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        alert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let accessKey = EventDetails.details?.secret
            if textField.text == accessKey?.lowercaseString {
                self.navigationController?.pushViewController(EventDetails, animated: true)
            }else{
                let alertMessage = UIAlertController(title: "Incorrect Key", message: "Please try entering the key again", preferredStyle: .Alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertMessage, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
    
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CrawlTableViewCell
        let event = events[indexPath.row]
        cell.nameOfCrawl?.text = event.title
        cell.dateOfCrawl?.text = event.date
        cell.descOfCrawl?.text = event.desc
        
        cell.backgroundViewCell.layer.cornerRadius = 3.0
        cell.backgroundViewCell.layer.masksToBounds = false
        cell.backgroundViewCell.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
        cell.backgroundViewCell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.backgroundViewCell.layer.shadowOpacity = 0.8
        
        let eventPhoto = event.photo
        let storageEventPic = storage.referenceForURL(eventPhoto!)
        storageEventPic.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let myEventImage: UIImage! = UIImage(data: data!)
                print(myEventImage)
                cell.eventImage.layer.borderColor = UIColor(red: 59.0, green: 175.0, blue: 218.0, alpha: 1.0).CGColor
                cell.eventImage.layer.borderWidth = 2.0
                cell.eventImage.layer.cornerRadius = 2.0
                cell.eventImage.image = myEventImage
            }}
        
        return cell
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