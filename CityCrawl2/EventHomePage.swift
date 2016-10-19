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
import Cosmos
import FirebaseStorage

class EventHomePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var barNames: [String]=[""]
    var barRating = [1.0, 2.0, 4.0, 5.0, 4.0, 5.0, 1.0, 2.0, 4.0, 5.0, 4.0, 1.0, 2.0, 4.0, 5.0, 4.0, 1.0, 2.0, 4.0, 5.0, 4.0, 1.0, 2.0, 4.0, 5.0]
    var details:Event?
    
    let storage = FIRStorage.storage()
    
    @IBOutlet weak var crawlDate: UILabel!
    @IBOutlet weak var crawlTitle: UILabel!
    @IBOutlet weak var crawlDescription: UILabel!
    @IBOutlet weak var barTableView: UITableView!
    @IBAction func mapImageTouched(sender: AnyObject) {
    }

    let uID = FIRAuth.auth()?.currentUser?.uid
    
    @IBOutlet weak var mapImage: UIButton!
    
    @IBAction func joinChatButtonPressed(sender: UIBarButtonItem) {
        switchToNaVViewController()
    }
    
    var databaseRef:FIRDatabaseReference!
    var ratingDatabase:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingDatabase = FIRDatabase.database().reference().child("ratings").child(uID!)
        databaseRef = FIRDatabase.database().reference().child("bars")
        startObservingBars()
        startObservingRating()
        
        if self.details != nil {
            crawlTitle.text = self.details?.title
            crawlDate.text = self.details?.date
            //crawlDescription.text = self.details?.desc
            let mapData = details?.map
            let storagePic = storage.referenceForURL(mapData!)
            storagePic.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let myImage: UIImage! = UIImage(data: data!)
                    
                    self.mapImage.setImage(myImage, forState: UIControlState.Normal)
                }
            }        
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
    
    func startObservingRating() {
        ratingDatabase.observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
            
            let thisRating = snapshot.value! as! NSDictionary
            let otherRating = thisRating[self.details!.key] as! NSDictionary
            let thirdRating = otherRating.allValues
            print(otherRating)
            print(thirdRating)
            self.barRating = (thirdRating as? [Double])!
            print(self.barRating)
            self.barTableView.reloadData()
            //self.barRating = (thirdRating.allValues as? [Double])!
            
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
        
        let bar = self.barNames[indexPath.row]
        let neighborhood = self.details?.key!
        
        cell.starView.rating = barRating[indexPath.row]
        cell.barNameLabel?.text = barNames[indexPath.row]
            cell.starView.didFinishTouchingCosmos = { rating in
                self.ratingDatabase.child("\(neighborhood!)/\(bar)").setValue(rating)
                print(rating)
        }
        
        return cell
        }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            if let destinationVC = segue.destinationViewController as? DetailViewController {
                destinationVC.newImage = (details?.map)!
            }}}
    
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

//
//let fullStarImage:  UIImage = UIImage(named: "starFull.png")!
//let halfStarImage:  UIImage = UIImage(named: "starHalf.png")!
//let emptyStarImage: UIImage = UIImage(named: "starEmpty.png")!
//
//func getStarImage(starNumber: Double, forRating rating: Double) -> UIImage {
//    if rating >= starNumber {
//        return fullStarImage
//    } else if rating + 0.5 == starNumber {
//        return halfStarImage
//    } else {
//        return emptyStarImage
//    }
//}
//
//if let ourRating = object?["OurRating"] as? Double {
//    cell?.star1.image = getStarImage(1, forRating: ourRating)
//    cell?.star2.image = getStarImage(2, forRating: ourRating)
//    cell?.star3.image = getStarImage(3, forRating: ourRating)
//    cell?.star4.image = getStarImage(4, forRating: ourRating)
//    cell?.star5.image = getStarImage(5, forRating: ourRating)
//}
