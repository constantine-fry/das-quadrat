//
//  UserTaskFactory.swift
//  Foursquare
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//


public class Users: Endpoint {
    
    // MARK: - Main
    
    public func get(userID: String, completionHandler:  ResponseCompletionHandler) -> Task {
        let path = "users/".stringByAppendingString(userID)
        let task = self.taskWithPath(path, parameters: nil, HTTPMethod: "POST", completionHandler)
        task.start()
        return task
    }
    
    // MARK: - General
    
        // requests
        // search
    
    // MARK: - Aspects
    
        // checkins
        // friends
        // lists
        // mayorships
        // photos
        // tips
        // venuehistory
        // venuelikes
    
    // MARK: - Actions
    
         // approve
         // deny
         // setpings
         // unfriend
         // update
}
