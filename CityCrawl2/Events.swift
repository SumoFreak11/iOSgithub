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
    let map:String!
    let secret:String!
    let ticket:String!
    let photo:String!
    
    init (title:String, map:String, photo:String, ticket:String, date:String, desc:String, key:String = "", secret:String) {
        self.key = key
        self.title = title
        self.date = date
        self.eventRef = FIRDatabase.database().reference().child("events") // or nil
        self.desc = desc
        self.map = map
        self.secret = secret
        self.ticket = ticket
        self.photo = photo
    }
    
    init (snapshot:FIRDataSnapshot) {
        key = snapshot.key
        eventRef = snapshot.ref
        
        if let eventContent = snapshot.value!["title"] as? String {
            title = eventContent
        }else{
            title = ""
        }
        
        if let eventMap = snapshot.value!["map"] as? String {
            map = eventMap
        }else{
            map = ""
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
        
        if let eventSecret = snapshot.value!["secret"] as? String {
            secret = eventSecret
        }else{
            secret = ""
        }
        
        if let eventTicket = snapshot.value!["ticket"] as? String {
            ticket = eventTicket
        }else{
            ticket = ""
        }
        
        if let eventPhoto = snapshot.value!["photo"] as? String {
            photo = eventPhoto
        }else{
            photo = ""
        }
    
        func toAnyObject() -> AnyObject {
            return ["title":title, "date":date, "desc":desc]
        }
        
    }
    
}
