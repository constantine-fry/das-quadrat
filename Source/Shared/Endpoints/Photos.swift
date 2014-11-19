//
//  PhotosEndPoint.swift
//  Quadrat
//
//  Created by Constantine Fry on 30/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public enum FoursquareId {
    case CheckinId(String)
    case TipId(String)
    case VenueId(String)
    case PageId(String)
    
    func parameter() -> Parameters {
        switch self {
        case .CheckinId(let idString):
            return [Parameter.checkinId: idString]
        case .TipId(let idString):
            return [Parameter.tipId: idString]
        case .VenueId(let idString):
            return [Parameter.venueId: idString]
        case .PageId(let idString):
            return [Parameter.pageId: idString]
        }
    }
}

public class Photos : Endpoint {
    override var endpoint   : String {
        return "photos"
    }
    // MARK: - Main
    
    // MARK: - General
    
    public func add(fromURL: NSURL, foursquareID: FoursquareId, parameters: Parameters?, completionHandler:  ResponseCompletionHandler?) -> Task {
        let path = "add"
        var allParameters = foursquareID.parameter()
        if parameters != nil {
            allParameters += parameters!
        }
        let task = self.uploadTaskFromURL(fromURL, path: path, parameters: allParameters, HTTPMethod: "POST", completionHandler)
        task.start()
        return task
    }
    
    // MARK: - Aspects
    
    // MARK: - Actions
}
