//
//  UserTaskFactory.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Users: Endpoint {
    override var endpoint   : String {
        return "users"
    }
    
    // MARK: - Main
    
    public func get(userID: String, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = userID
        let task = self.taskWithPath(path, parameters: nil, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // MARK: - General
    
    // requests
    public func requests(completionHandler:  ResponseCompletionHandler) -> Task {
        let path = "requests"
        let task = self.taskWithPath(path, parameters: nil, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // search
    public func search(parameters: Parameters, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = "search"
        let task = self.taskWithPath(path, parameters: parameters, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // MARK: - Aspects
    
    // checkins
    public func checkins(parameters: Parameters, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = "self/checkins"
        let task = self.taskWithPath(path, parameters: parameters, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // friends
    public func friends(userID: String, parameters: Parameters, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = userID + "/friends"
        let task = self.taskWithPath(path, parameters: parameters, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // lists
    public func lists(userID: String, parameters: Parameters, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = userID + "/lists"
        let task = self.taskWithPath(path, parameters: parameters, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // mayorships
    public func lists(userID: String, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = userID + "/lists"
        let task = self.taskWithPath(path, parameters: nil, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // photos
    public func photos(parameters: Parameters, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = "self/photos"
        let task = self.taskWithPath(path, parameters: parameters, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // tastes
    public func tastes(parameters: Parameters, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = "self/tastes"
        let task = self.taskWithPath(path, parameters: parameters, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // tips
        // This endpoint is deprecated. Use /lists/USER_ID/tips instead.
    
    // venuehistory
    public func venuehistory(parameters: Parameters, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = "self/venuehistory"
        let task = self.taskWithPath(path, parameters: parameters, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // venuelikes
    public func venuelikes(userID: String, parameters: Parameters, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = userID + "/venuelikes"
        let task = self.taskWithPath(path, parameters: parameters, HTTPMethod: "GET", completionHandler)
        return task
    }
    
    // MARK: - Actions
    
    // approve
    public func approve(userID: String, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = userID + "/approve"
        let task = self.taskWithPath(path, parameters: nil, HTTPMethod: "POST", completionHandler)
        return task
    }
    
    // deny
    public func deny(userID: String, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = userID + "/deny"
        let task = self.taskWithPath(path, parameters: nil, HTTPMethod: "POST", completionHandler)
        return task
    }
    
    // setpings
    public func setpings(userID: String, value: Bool, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = userID + "/setpings"
        let parameters = [Parameter.value: (value) ? "true":"false"]
        let task = self.taskWithPath(path, parameters: parameters, HTTPMethod: "POST", completionHandler)
        task.start()
        return task
    }
    
    // unfriend
    public func unfriend(userID: String, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = userID + "/unfriend"
        let task = self.taskWithPath(path, parameters: nil, HTTPMethod: "POST", completionHandler)
        return task
    }
    
    // update
    public func update(photoURL: NSURL, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = "self/update"
        let task = self.uploadTaskFromURL(photoURL, path: path, parameters: nil, HTTPMethod: "POST", completionHandler: completionHandler)
        return task
    }
}
