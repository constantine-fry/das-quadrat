//
//  Checkins.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Checkins: Endpoint {
    
    override var endpoint   : String {
        return "checkins"
    }
    
    public func get(checkinId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(checkinId, parameters: nil, completionHandler)
    }
    
    // MARK: - General
    
    // add
    public func add(venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "add"
        var allParameters = [Parameter.venueId:venueId]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler)
    }

    // recent
    public func recent(parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "recent"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }

    
    // MARK: - Aspects
    
    // likes
    public func likes(checkinId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = checkinId + "/likes"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // MARK: - Actions
    
    // addcomment
    public func addcomment(checkinId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = checkinId + "/addcomment"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // addpost
    public func addpost(checkinId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = checkinId + "/addpost"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // deletecomment
    public func deletecomment(checkinId: String, commentId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = checkinId + "/deletecomment"
        let parameters = [Parameter.commentId:commentId]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // like
    public func like(checkinId: String, like: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = checkinId + "/like"
        let parameters = [Parameter.set: (like) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
}
