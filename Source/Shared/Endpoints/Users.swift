//
//  Users.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Users: Endpoint {
    override var endpoint: String {
        return "users"
    }
    
    public func get(userID: String = UserSelf, completionHandler:  ResponseClosure? = nil) -> Task {
        return self.getWithPath(userID, parameters: nil, completionHandler)
    }
    
    // MARK: - General
    
    // requests
    public func requests(completionHandler:  ResponseClosure? = nil) -> Task {
        let path = "requests"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // search
    public func search(parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = "search"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // MARK: - Aspects
    
    // checkins
    public func checkins(userID: String = UserSelf, parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/checkins"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // friends
    public func friends(userID: String = UserSelf, parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/friends"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // lists
    public func lists(userID: String = UserSelf, parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/lists"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // mayorships
    public func lists(userID: String = UserSelf, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/lists"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // photos
    public func photos(userID: String = UserSelf, parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/photos"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // tastes
    public func tastes(userID: String = UserSelf, parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/tastes"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // venuehistory
    public func venuehistory(userID: String = UserSelf, parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/venuehistory"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // venuelikes
    public func venuelikes(userID: String = UserSelf, parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/venuelikes"
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // MARK: - Actions
    
    // approve
    public func approve(userID: String, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/approve"
        return self.postWithPath(path, parameters: nil, completionHandler)
    }
    
    // deny
    public func deny(userID: String, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/deny"
        return self.postWithPath(path, parameters: nil, completionHandler)
    }
    
    // setpings
    public func setpings(userID: String, value: Bool, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/setpings"
        let parameters = [Parameter.value: (value) ? "true":"false"]
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // unfriend
    public func unfriend(userID: String, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userID + "/unfriend"
        return self.postWithPath(path, parameters: nil, completionHandler)
    }
    
    // update
    public func update(photoURL: NSURL, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = UserSelf + "/update"
        let task = self.uploadTaskFromURL(photoURL, path: path, parameters: nil, completionHandler: completionHandler)
        return task
    }
}
