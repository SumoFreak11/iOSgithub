//
//  Events.swift
//  CityCrawl2
//
//  Created by Arthur Bahr on 8/16/16.
//  Copyright © 2016 TurnupSF. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct Event {

    let key:String!
    let title:String!
    let date:String!
    let eventRef:FIRDatabaseReference?
    let desc:String!
    
    init (title:String, date:String, desc:String, key:String = "") {
        self.key = key
        self.title = title
        self.date = date
        self.eventRef = FIRDatabase.database().reference().child("events") // or nil
        self.desc = desc
    }
    
    init (snapshot:FIRDataSnapshot) {
        key = snapshot.key
        eventRef = snapshot.ref
        
        if let eventContent = snapshot.value!["title"] as? String {
            title = eventContent
        }else{
            title = ""
        }
        
        if let eventDate = snapshot.value!["date"] as? String {
            date = eventDate
        }else{
            date = ""
        }
        
        if let eventDesc = snapshot.value!["desc"] as? String {
            desc = eventDesc
        }else{
            desc = ""
        }
    
        func toAnyObject() -> AnyObject {
            return ["title":title, "date":date]
        }
        
    }
    
}
