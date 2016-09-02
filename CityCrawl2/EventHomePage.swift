//
//  EventHomePage.swift
//  CityCrawl2
//
//  Created by Arthur Bahr on 8/22/16.
//  Copyright © 2016 TurnupSF. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class EventHomePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var barNames: [String]=[""]
    var details:Event?
    
    @IBOutlet weak var crawlDate: UILabel!
    @IBOutlet weak var crawlTitle: UILabel!
    @IBOutlet weak var crawlDescription: UILabel!
    @IBOutlet weak var barTableView: UITableView!
    
    
    @IBAction func joinChatButtonPressed(sender: UIBarButtonItem) {
        switchToNaVViewController()
    }
    
    var databaseRef:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = FIRDatabase.database().reference().child("bars")
        startObservingBars()
        
        if self.details != nil {
            crawlTitle.text = self.details?.title
            crawlDate.text = self.details?.date
            crawlDescription.text = self.details?.desc
        }
            }
    
    func startObservingBars() {
        databaseRef.observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
            let neighborhoods = snapshot.value as! NSDictionary
            let barsForNeighborhood = neighborhoods[self.details!.key] as! NSDictionary
            self.barNames = (barsForNeighborhood.allValues as? [String])!
            print(self.barNames)
            self.barTableView.reloadData()

        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barNames.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as! BarTableViewCell
        
        cell.barNameLabel?.text = barNames[indexPath.row]
        
        return cell
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
}
