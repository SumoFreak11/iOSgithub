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

class CrawlTableViewController: UITableViewController {
    
    var databaseRef:FIRDatabaseReference!
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = FIRDatabase.database().reference().child("events")
        startObservingDB()
        
    }
    
    @IBAction func logoutButtonTapped(sender: UIBarButtonItem) {
        try! FIRAuth.auth()!.signOut()
        // nav to home page
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
            self.tableView.reloadData()
            }) { (error:NSError) in
                print(error.description)
    }
        }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let EventDetails = self.storyboard!.instantiateViewControllerWithIdentifier("EventDetails") as! EventHomePage
        EventDetails.details = events[indexPath.row]
        self.navigationController?.pushViewController(EventDetails, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CrawlTableViewCell
        let event = events[indexPath.row]
        cell.nameOfCrawl?.text = event.title
        cell.dateOfCrawl?.text = event.date
        
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