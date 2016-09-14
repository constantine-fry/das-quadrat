//
//  Venuegroups.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

open class VenueGroups: Endpoint {
    override var endpoint: String {
        return "venuegroups"
    }
    
    /** https://developer.foursquare.com/docs/venuegroups/venuegroups */
    open func get(_ groupId: String, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(groupId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/venuegroups/add */
    open func add(_ name: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "add"
        var allParameters = [Parameter.name: name]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venuegroups/delete */
    open func delete(_ groupId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/delete"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venuegroups/list */
    open func list(_ completionHandler: ResponseClosure? = nil) -> Task {
        let path = "list"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/venuegroups/timeseries */
    open func timeseries(_ groupId: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = groupId + "/timeseries"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/venuegroups/addvenue */
    open func addvenue(_ groupId: String, venueId: [String], completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/addvenue"
        let parameters = [Parameter.venueId: venueId.joined(separator: ",")]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venuegroups/edit */
    open func edit(_ groupId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/edit"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venuegroups/removevenue */
    open func removevenue(_ groupId: String, venueId: [String], completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/removevenue"
        let parameters = [Parameter.venueId: venueId.joined(separator: ",")]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venuegroups/update */
    open func update(_ groupId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/update"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
}
