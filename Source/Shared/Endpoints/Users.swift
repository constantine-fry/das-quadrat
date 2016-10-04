//
//  Users.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public let UserSelf = "self"

open class Users: Endpoint {
    override var endpoint: String {
        return "users"
    }
    
    /** https://developer.foursquare.com/docs/users/users */
    open func get(_ userId: String = UserSelf, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(userId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/users/requests */
    open func requests(_ completionHandler: ResponseClosure? = nil) -> Task {
        let path = "requests"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/search */
    open func search(_ parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "search"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/users/checkins */
    open func checkins(_ userId: String = UserSelf,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = userId + "/checkins"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/friends */
    open func friends(_ userId: String = UserSelf,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = userId + "/friends"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/lists */
    open func lists(_ userId: String = UserSelf,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = userId + "/lists"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/mayorships */
    open func mayorships(_ userId: String = UserSelf, completionHandler: ResponseClosure? = nil) -> Task {
        let path = userId + "/mayorships"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/photos */
    open func photos(_ userId: String = UserSelf,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = userId + "/photos"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/tastes */
    open func tastes(_ userId: String = UserSelf,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = userId + "/tastes"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/venuehistory */
    open func venuehistory(_ userId: String = UserSelf,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = userId + "/venuehistory"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/venuelikes */
    open func venuelikes(_ userId: String = UserSelf,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = userId + "/venuelikes"
            return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/users/approve */
    open func approve(_ userId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = userId + "/approve"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/deny */
    open func deny(_ userId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = userId + "/deny"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/setpings */
    open func setpings(_ userId: String, value: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = userId + "/setpings"
        let parameters = [Parameter.value: (value) ? "true":"false"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/unfriend */
    open func unfriend(_ userId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = userId + "/unfriend"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/users/update */
    open func update(_ photoURL: URL, completionHandler: ResponseClosure? = nil) -> Task {
        let path = UserSelf + "/update"
        let task = self.uploadTaskFromURL(photoURL, path: path, parameters: nil, completionHandler: completionHandler)
        return task
    }
}
