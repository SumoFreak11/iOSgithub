//
//  DetailViewController.swift
//  CityCrawl2
//
//  Created by Arthur Bahr on 9/6/16.
//  Copyright © 2016 TurnupSF. All rights reserved.
//

import UIKit
import FirebaseStorage

class DetailViewController: UIViewController {

    var newImage: String = ""
    let storage = FIRStorage.storage()

    @IBOutlet weak var mapEnlarged: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(newImage)

        if newImage != "" {
            let mapData = newImage
            print(mapData)
            let storagePic = storage.referenceForURL(mapData)
            storagePic.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    var myImage: UIImage! = UIImage(data: data!)
                    self.mapEnlarged.image = myImage
                }}
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
