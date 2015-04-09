//
//  Events.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Events: Endpoint {
    override var endpoint: String {
        return "events"
    }
    
    /** https://developer.foursquare.com/docs/events/events */
    public func get(eventId: String, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(eventId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/events/categories */
    public func categories(completionHandler: ResponseClosure? = nil) -> Task {
        let path = "categories"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/events/search */
    public func search(domain: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "search"
        var allParameters = [Parameter.domain: domain]
        allParameters += parameters
        return self.getWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/events/add */
    public func add(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "add"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
}
