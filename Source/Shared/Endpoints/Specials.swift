//
//  Specials.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

open class Specials: Endpoint {
    override var endpoint: String {
        return "specials"
    }
    
    /** https://developer.foursquare.com/docs/specials/specials */
    open func get(_ specialId: String, venueId: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            var allParameters = [Parameter.venueId:venueId]
            allParameters += parameters
            return self.getWithPath(specialId, parameters: allParameters, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/specials/add */
    open func add(_ parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "add"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/specials/list */
    open func all(_ parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "list"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/specials/search */
    open func search(_ ll: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "search"
        var allParameters = [Parameter.ll:ll]
        allParameters += parameters
        return self.getWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }

    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/specials/flag */
    open func flag(_ specialId: String, venueId: String,
        problem: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = "add"
            var allParameters = ["ID": specialId, Parameter.venueId:venueId, Parameter.problem:problem]
            allParameters += allParameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
}
