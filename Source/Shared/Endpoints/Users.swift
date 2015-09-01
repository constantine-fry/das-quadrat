//
//  Users.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public let UserSelf = "self"

public class Users: Endpoint {
    override var endpoint: String {
        return "users"
    }
    
    /** https://developer.foursquare.com/docs/users/users */
    public func get(userId: String = UserSelf, completionHandler:  ResponseClosure? = nil) -> Task {
        return self.getWithPath(userId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/users/requests */
    public func requests(completionHandler:  ResponseClosure? = nil) -> Task {
        let path = "requests"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/search */
    public func search(parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = "search"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/users/checkins */
    public func checkins(userId: String = UserSelf,
        parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
            let path = userId + "/checkins"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/friends */
    public func friends(userId: String = UserSelf,
        parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
            let path = userId + "/friends"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/lists */
    public func lists(userId: String = UserSelf,
        parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
            let path = userId + "/lists"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/mayorships */
    public func mayorships(userId: String = UserSelf,
        completionHandler:  ResponseClosure? = nil) -> Task {
            let path = userId + "/mayorships"
            return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/photos */
    public func photos(userId: String = UserSelf,
        parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
            let path = userId + "/photos"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/tastes */
    public func tastes(userId: String = UserSelf,
        parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
            let path = userId + "/tastes"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/venuehistory */
    public func venuehistory(userId: String = UserSelf,
        parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
            let path = userId + "/venuehistory"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/venuelikes */
    public func venuelikes(userId: String = UserSelf,
        parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
            let path = userId + "/venuelikes"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/users/approve */
    public func approve(userId: String, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userId + "/approve"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/deny */
    public func deny(userId: String, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userId + "/deny"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/setpings */
    public func setpings(userId: String, value: Bool, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userId + "/setpings"
        let parameters = [Parameter.value: (value) ? "true":"false"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/unfriend */
    public func unfriend(userId: String, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = userId + "/unfriend"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/update */
    public func update(photoURL: NSURL, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = UserSelf + "/update"
        let task = self.uploadTaskFromURL(photoURL, path: path, parameters: nil, completionHandler: completionHandler)
        return task
    }
}
