//
//  Tips.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Tips: Endpoint {
    override var endpoint: String {
        return "tips"
    }
    
    /** https://developer.foursquare.com/docs/tips/tips */
    public func get(tipId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(tipId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/tips/add */
    public func add(venueId: String, text: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = "add"
            var allParameters = [Parameter.venueId:venueId, Parameter.text:text]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/tips/likes */
    public func likes(tipID: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/likes"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/tips/listed */
    public func listed(tipId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipId + "/listed"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/tips/saves */
    public func saves(tipId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipId + "/saves"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/tips/flag */
    public func flag(tipId: String, problem: String,
        parameters: Parameters?,  completionHandler: ResponseClosure? = nil) -> Task {
            let path = tipId + "/flag"
            var allParameters = [Parameter.problem:problem]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/tips/like */
    public func like(tipId: String, like: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipId + "/like"
        let parameters = [Parameter.set: (like) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/tips/unmark */
    public func unmark(tipId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipId + "/unmark"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
}

