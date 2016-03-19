//
//  SearchTableViewController.swift
//  Demo-iOS
//
//  Created by Constantine Fry on 30/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

import QuadratTouch

protocol SearchTableViewControllerDelegate: class {
    func searchTableViewController(controller: SearchTableViewController, didSelectVenue venue:JSONParameters)
}

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    var session: Session!
    var location: CLLocation!
    var venues: [JSONParameters]!
    let distanceFormatter = MKDistanceFormatter()
    var currentTask: Task?
    
    weak var delegate: SearchTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let strippedString = searchController.searchBar.text!.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        
        if self.location == nil {
            return
        }
        
        self.currentTask?.cancel()
        var parameters = [Parameter.query:strippedString]
        parameters += self.location.parameters()
        self.currentTask = session.venues.search(parameters) {
            (result) -> Void in
            if let response = result.response {
                self.venues = response["venues"] as? [JSONParameters]
                self.tableView.reloadData()
            }
        }
        self.currentTask?.start()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        let venue = venues[indexPath.row]
        if let venueLocation = venue["location"] as? JSONParameters {
            var detailText = ""
            if let distance = venueLocation["distance"] as? CLLocationDistance {
                detailText = distanceFormatter.stringFromDistance(distance)
            }
            if let address = venueLocation["address"] as? String {
                detailText = detailText +  " - " + address
            }
            cell.detailTextLabel?.text = detailText
        }
        cell.textLabel?.text = venue["name"] as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let venues = self.venues {
            return venues.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let venueInfo = self.venues![indexPath.row] as JSONParameters!
        self.delegate?.searchTableViewController(self, didSelectVenue: venueInfo)
    }

}
