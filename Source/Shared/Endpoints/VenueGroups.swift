//
//  Venuegroups.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class VenueGroups: Endpoint {
    override var endpoint   : String {
        return "venuegroups"
    }
    
    public func get(groupId: String, completionHandler:  ResponseClosure? = nil) -> Task {
        return self.getWithPath(groupId, parameters: nil, completionHandler)
    }
    
    // MARK: - General
    
    // add
    public func add(name: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "add"
        var allParameters = [Parameter.name: name]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler)
    }
    
    // delete
    public func delete(groupId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/delete"
        return self.postWithPath(path, parameters: nil, completionHandler)
    }
    
    // list
    public func list(completionHandler: ResponseClosure? = nil) -> Task {
        let path = "list"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // MARK: - Aspects
    
    // timeseries
    public func timeseries(groupId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/timeseries"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // MARK: - Actions
    
    // addvenue
    public func addvenue(groupId: String, venueId: [String], completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/addvenue"
        let parameters = [Parameter.venueId:join(",", venueId)]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // edit
    public func edit(groupId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/edit"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // removevenue
    public func removevenue(groupId: String,  venueId: [String], completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/removevenue"
        let parameters = [Parameter.venueId:join(",", venueId)]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // update
    public func update(groupId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = groupId + "/update"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
}
