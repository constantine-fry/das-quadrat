//
//  Venues.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Venues: Endpoint {
    override var endpoint   : String {
        return "venues"
    }
    
    public func get(venueId: String, completionHandler:  ResponseClosure? = nil) -> Task {
        return self.getWithPath(venueId, parameters: nil, completionHandler)
    }
    
    // MARK: - General
    
    // add
    public func add(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "add"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // categories
    public func categories(completionHandler: ResponseClosure? = nil) -> Task {
        let path = "categories"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // explore
    public func explore(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "explore"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // managed
    public func managed(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "managed"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // search
    public func search(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "search"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // suggestcompletion
    public func suggestcompletion(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "suggestcompletion"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }

    // timeseries
    public func timeseries(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "timeseries"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // trending
    public func trending(ll:String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "trending"
        var allParameters = [Parameter.ll:ll]
        allParameters += parameters
        return self.getWithPath(path, parameters: allParameters, completionHandler)
    }
    
    // MARK: - Aspects
    
    // events
    public func events(venuId:String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/events"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // herenow
    public func herenow(venuId:String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/herenow"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // hours
    public func hours(venuId:String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/hours"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // likes
    public func likes(venuId:String, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = venuId + "/likes"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // links
    public func links(venuId:String, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = venuId + "/links"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // listed
    public func listed(venuId:String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/listed"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // menu
    public func menu(venuId:String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/menu"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // nextvenues
    public func nextvenues(venuId:String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/nextvenues"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // photos
    public func photos(venuId:String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/photos"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // similar
    public func similar(venuId:String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/similar"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // stats
    public func stats(venuId:String,  parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/stats"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // tips
    public func tips(venuId:String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/tips"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // MARK: - Actions
    
    // claim
    public func claim(venuId:String, visible: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/claim"
        let parameters = [Parameter.visible: (visible) ? "true":"false"]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // dislike
    public func dislike(venuId:String, dislike: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/dislike"
        let parameters = [Parameter.set: (dislike) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // edit
    public func edit(venuId:String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/edit"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // flag
    public func flag(venuId:String, problem: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/flag"
        var allParameters = [Parameter.problem:problem]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler)
    }
    
    // like
    public func like(venuId:String, like: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/like"
        let parameters = [Parameter.set: (like) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // proposeedit
    public func proposeedit(venuId:String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/proposeedit"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // setrole
    public func setrole(venuId:String, userId: String, role: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/setrole"
        var allParameters = [Parameter.userId:userId, Parameter.role:role]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler)
    }
    
    // setsinglelocation
    public func setsinglelocation(venuId:String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = venuId + "/setsinglelocation"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
}
