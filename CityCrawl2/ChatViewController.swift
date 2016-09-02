//
//  ChatViewController.swift
//  CityCrawl2
//
//  Created by Arthur Bahr on 7/25/16.
//  Copyright © 2016 TurnupSF. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseDatabase
import Firebase
import FirebaseStorage
import FirebaseAuth

class ChatViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    
    var messageRef = FIRDatabase.database().reference().child("messages")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        self.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName


        // Do any additional setup after loading the view.
        
            observeMessages()
    }

    func observeMessages() {
        let messageQuery = messageRef.queryLimitedToLast(25)
        messageQuery.observeEventType(.ChildAdded, withBlock: { snapshot in
            if let dict = snapshot.value as? [String: AnyObject] {
               // let mediaType = dict["mediaType"] as! String
                let senderId = dict["senderId"] as! String
                let senderName = dict["senderName"] as! String
                
                if let text = dict["text"] as? String {
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                }else {
                    let fileUrl = dict["fileUrl"] as! String
                    let data = NSData(contentsOfURL: NSURL(string: fileUrl)!)
                    let uploadPicture = UIImage(data: data!)
                    let uploadPhoto = JSQPhotoMediaItem(image: uploadPicture)
                    self.messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: uploadPhoto))
                }
                self.finishReceivingMessage()
                //self.collectionView!.reloadData()
                
            }
    })
    }
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        //messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        //collectionView?.reloadData()
        //print(messages)
        let newMessage = messageRef.childByAutoId()
        let messageData = ["text": text, "senderId": senderId, "senderName": senderDisplayName, "mediaType": "TEXT"]
        newMessage.setValue(messageData)
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("did press accessory button")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //self.presentViewController(imagePicker, animated: true, completion: nil)
        
        
        // START CAMERA OPTIONS
        let actionSheet = UIAlertController(title: "Choose your photo", message: "",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let libButton = UIAlertAction(title: "Photo library", style: UIAlertActionStyle.Default) { (libSelected) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }

        actionSheet.addAction(libButton)
        
        let camButton = UIAlertAction(title: "Take picture", style: UIAlertActionStyle.Default) { (camSelected) -> Void in
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionSheet.addAction(camButton)
        actionSheet.addAction(cancelButton)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        // FINISH CAMERA OPTIONS
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        //outgoingBubbleImageView = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor!)
        //incomingBubbleImageView = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor!)
        return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0))
    }
        
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
        
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of items:\(messages.count)")
        print (FIRAuth.auth()?.currentUser?.displayName!)

        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonDidTapped(sender: AnyObject) {
        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // From any view controller -> home
        let LoginVC = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! SignUpViewController
        // Get the app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Set navigation controller as root controller
        appDelegate.window?.rootViewController = LoginVC
    }
    
    func sendMedia(picture: UIImage?) {
        print(picture)
        print(FIRStorage.storage().reference())
        let filePath = "\(FIRAuth.auth()!.currentUser!)/\(NSDate.timeIntervalSinceReferenceDate())"
        print(filePath)
        let data = UIImageJPEGRepresentation(picture!, 0.1)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpg"
        FIRStorage.storage().reference().child(filePath).putData(data!, metadata: metadata) {
            (metadata, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            let fileUrl = metadata!.downloadURLs![0].absoluteString
            let newMessage = self.messageRef.childByAutoId()
            let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "mediaType": "PHOTO"]
            newMessage.setValue(messageData)
        }
    }


}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("did finish picking")
        print(info)
        
        let picture = info[UIImagePickerControllerOriginalImage] as? UIImage
        let photo = JSQPhotoMediaItem(image: picture)
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
        sendMedia(picture)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        collectionView?.reloadData()

    }
}
