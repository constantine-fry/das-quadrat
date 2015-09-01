//
//  Venues.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Venues: Endpoint {
    override var endpoint: String {
        return "venues"
    }
    
    /** https://developer.foursquare.com/docs/venues/venues */
    public func get(venueId: String, completionHandler:  ResponseClosure? = nil) -> Task {
        return self.getWithPath(venueId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/venues/add */
    public func add(name: String, ll: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = "add"
            var allParameters = [Parameter.name:name, Parameter.ll:ll]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/categories */
    public func categories(completionHandler: ResponseClosure? = nil) -> Task {
        let path = "categories"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/explore */
    public func explore(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "explore"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/managed */
    public func managed(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "managed"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/search */
    public func search(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "search"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/suggestcompletion */
    public func suggestcompletion(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "suggestcompletion"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/timeseries */
    public func timeseries(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "timeseries"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/trending */
    public func trending(ll: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "trending"
        var allParameters = [Parameter.ll:ll]
        allParameters += parameters
        return self.getWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/venues/events */
    public func events(venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/events"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/herenow */
    public func herenow(venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/herenow"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/hours */
    public func hours(venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/hours"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/likes */
    public func likes(venueId: String, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = venueId + "/likes"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/links */
    public func links(venueId: String, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = venueId + "/links"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/listed */
    public func listed(venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/listed"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/menu */
    public func menu(venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/menu"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/nextvenues */
    public func nextvenues(venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/nextvenues"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/photos */
    public func photos(venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/photos"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/similar */
    public func similar(venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/similar"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/stats */
    public func stats(venueId: String,  parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/stats"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/tips */
    public func tips(venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/tips"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/venues/claim */
    public func claim(venueId: String, visible: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/claim"
        let parameters = [Parameter.visible: (visible) ? "true":"false"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/dislike */
    public func dislike(venueId: String, dislike: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/dislike"
        let parameters = [Parameter.set: (dislike) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/edit */
    public func edit(venueId:String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/edit"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/flag */
    public func flag(venueId: String, problem: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = venueId + "/flag"
            var allParameters = [Parameter.problem:problem]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/like */
    public func like(venueId: String, like: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/like"
        let parameters = [Parameter.set: (like) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/proposeedit */
    public func proposeedit(venueId: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = venueId + "/proposeedit"
            return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/setrole */
    public func setrole(venueId: String, userId: String, role: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = venueId + "/setrole"
            var allParameters = [Parameter.userId:userId, Parameter.role:role]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/venues/setsinglelocation */
    public func setsinglelocation(venueId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venueId + "/setsinglelocation"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
}
