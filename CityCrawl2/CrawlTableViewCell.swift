//
//  CrawlTableViewCell.swift
//  CityCrawl2
//
//  Created by Arthur Bahr on 8/19/16.
//  Copyright © 2016 TurnupSF. All rights reserved.
//

import Foundation
import UIKit


class CrawlTableViewCell: UITableViewCell {
    
    @IBAction func ticketURL(sender: AnyObject) {
    
    }

    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var nameOfCrawl: UILabel!
    @IBOutlet weak var dateOfCrawl: UILabel!
    @IBOutlet weak var descOfCrawl: UILabel!
    
    @IBOutlet weak var backgroundViewCell: UIView!

}