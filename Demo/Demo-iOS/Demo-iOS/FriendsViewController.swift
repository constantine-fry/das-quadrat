//
//  SecondViewController.swift
//  Demo-iOS
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import UIKit

import QuadratTouch

/** Shows list of friends. */
class FriendsViewController: UITableViewController {

    var session: Session?
    var friends: [JSONParameters]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = Session.sharedSession()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let task = session?.users.friends(parameters: nil) {
            (response) -> Void in
            if let items = response.response?["friends"] as JSONParameters? {
                if let friends = items["items"] as [JSONParameters]? {
                    self.friends = friends
                }
            }
            self.tableView.reloadData()
        }
        task?.start()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friends != nil {
            return friends!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as FriendTableViewCell
        let friendInfo = friends![indexPath.row]
        let firstName = friendInfo["firstName"] as String?
        let lastName = friendInfo["lastName"] as String?
        let fullName = ((firstName != nil) ? firstName! : "") + " " + ((lastName != nil) ? lastName! : "")
        cell.nameLabel?.text = fullName
        cell.photoImageView.image = nil
        downloadPhoto(friendInfo["photo"] as JSONParameters?) {
            (imageData) -> Void in
            let cell = tableView.cellForRowAtIndexPath(indexPath) as FriendTableViewCell?
            if cell != nil && imageData != nil {
                let image = UIImage(data: imageData!)
                cell!.photoImageView.image = image
            }
        }
        return cell
    }
    
    func downloadPhoto(photo: JSONParameters?, completionHandler: (imageData: NSData?) -> Void) {
        if photo != nil {
            let prefix = photo!["prefix"] as String
            let suffix = photo!["suffix"] as String
            let URLString = prefix + "100x100" + suffix
            let URL = NSURL(string: URLString)
            session?.downloadImageAtURL(URL!) {
                (imageData, error) -> Void in
                if !NSThread.isMainThread() {
                    fatalError("!!!")
                }
                completionHandler(imageData: imageData)
            }
        } else {
            completionHandler(imageData: nil)
        }
        
    }
    
    
}


