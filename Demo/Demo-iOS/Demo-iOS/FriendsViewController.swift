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
        self.session = Session.sharedSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let task = self.session?.users.friends(parameters: nil) {
            (response) -> Void in
            if let items = response.response?["friends"] as? JSONParameters {
                if let friends = items["items"] as? [JSONParameters] {
                    self.friends = friends
                }
            }
            self.tableView.reloadData()
        }
        task?.start()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let friends = self.friends {
            return friends.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendTableViewCell
        let friendInfo = friends![(indexPath as NSIndexPath).row]
        let firstName = friendInfo["firstName"] as? String
        let lastName = friendInfo["lastName"] as? String
        let fullName = ((firstName != nil) ? firstName! : "") + " " + ((lastName != nil) ? lastName! : "")
        cell.nameLabel?.text = fullName
        
        if let photo = friendInfo["photo"] as? JSONParameters  {
            let URL = photoURLFromJSONObject(photo)
            if let imageData = session?.cachedImageDataForURL(URL)  {
                cell.photoImageView.image = UIImage(data: imageData)
            } else {
                cell.photoImageView.image = nil
                self.session?.downloadImageAtURL(URL) {
                    (imageData, error) -> Void in
                    let cell = tableView.cellForRow(at: indexPath) as? FriendTableViewCell
                    if let cell = cell, let imageData = imageData {
                        let image = UIImage(data: imageData)
                        cell.photoImageView.image = image
                    }
                }
                
            }
            
        }
        
        return cell
    }
    
    func photoURLFromJSONObject(_ photo: JSONParameters) -> URL {
        let prefix = photo["prefix"] as! String
        let suffix = photo["suffix"] as! String
        let URLString = prefix + "100x100" + suffix
        let URL = Foundation.URL(string: URLString)
        return URL!
    }
    
}


