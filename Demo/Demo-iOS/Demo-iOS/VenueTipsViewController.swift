//
//  VenueDetailViewController.swift
//  Demo-iOS
//
//  Created by Constantine Fry on 29/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit

import QuadratTouch

/** Shows tips related to a venue. */
class VenueTipsViewController: UITableViewController {
    var venueId: String?
    var session: Session!
    var tips: [JSONParameters]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        let task = self.session.venues.get(self.venueId!) {
            (result) -> Void in
            if result.response != nil {
                if let venue = result.response!["venue"] as? JSONParameters {
                    if let tips = venue["tips"] as? JSONParameters {
                        var tipItems = [JSONParameters]()
                        if let groups = tips["groups"] as? [JSONParameters] {
                            for group in groups {
                                if let item = group["items"] as? [JSONParameters] {
                                    tipItems += item
                                }
                            }
                        }
                        self.tips = tipItems
                    }
                }
            } else {
                // Show error.
            }
            self.tableView.reloadData()
        }
        task.start()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tips != nil {
            return self.tips!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let tip = self.tips![indexPath.row]
        cell.textLabel?.text = tip["text"] as? String
        return cell
    }
}
