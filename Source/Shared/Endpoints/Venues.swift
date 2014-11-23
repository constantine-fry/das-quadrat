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
    
    public func get(venueId: String, completionHandler:  ResponseCompletionHandler? = nil) -> Task {
        return self.getWithPath(venueId, parameters: nil, completionHandler)
    }
    
    // MARK: - General
    
    // add
    public func add(parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "add"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // categories
    public func categories(completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "categories"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // explore
    public func explore(parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "explore"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // managed
    public func managed(parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "managed"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // search
    public func search(parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "search"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // suggestcompletion
    public func suggestcompletion(parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "suggestcompletion"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }

    // timeseries
    public func timeseries(parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "timeseries"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // trending
    public func trending(ll:String, parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "trending"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // MARK: - Aspects
    
    // events
    public func events(venuId:String, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "events"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // herenow
    public func herenow(venuId:String, parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "herenow"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // hours
    public func hours(venuId:String, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "hours"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // likes
    public func likes(venuId:String, completionHandler:  ResponseCompletionHandler? = nil) -> Task {
        let path = "likes"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // links
    public func links(venuId:String, completionHandler:  ResponseCompletionHandler? = nil) -> Task {
        let path = "links"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // listed
    public func listed(venuId:String, parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "listed"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // menu
    public func menu(venuId:String, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "menu"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // nextvenues
    public func nextvenues(venuId:String, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "nextvenues"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // photos
    public func photos(venuId:String, parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "photos"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // similar
    public func similar(venuId:String, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "similar"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // stats
    public func stats(venuId:String,  parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "stats"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // tips
    public func tips(venuId:String, parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "tips"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // MARK: - Actions
    
    // claim
    public func claim(venuId:String, visible: Bool, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "claim"
        let parameters = [Parameter.visible: (visible) ? "true":"false"]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // dislike
    public func dislike(venuId:String, dislike: Bool, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "dislike"
        let parameters = [Parameter.set: (dislike) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // edit
    public func edit(venuId:String, parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "edit"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // flag
    public func flag(venuId:String, problem: String, parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "flag"
        var allParameters = [Parameter.problem:problem]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler)
    }
    
    // like
    public func like(venuId:String, like: Bool, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "like"
        let parameters = [Parameter.set: (like) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // proposeedit
    public func proposeedit(venuId:String, parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "proposeedit"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // setrole
    public func setrole(venuId:String, userId: String, role: String, parameters: Parameters?, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "setrole"
        var allParameters = [Parameter.userId:userId, Parameter.role:role]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler)
    }
    
    // setsinglelocation
    public func setsinglelocation(venuId:String, completionHandler: ResponseCompletionHandler? = nil) -> Task {
        let path = "setsinglelocation"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
}
