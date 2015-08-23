//
//  Lists.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Lists: Endpoint {
    override var endpoint: String {
        return "lists"
    }
    
    /** https://developer.foursquare.com/docs/lists/lists */
    public func get(listId: String, parameters: Parameters?,
        completionHandler: ResponseClosure? = nil) -> Task {
            return self.getWithPath(listId, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/lists/add */
    public func add(name: String, text: String, parameters: Parameters?,
        completionHandler: ResponseClosure? = nil) -> Task {
            let path = "add"
            var allParameters = [Parameter.name:name, Parameter.text:text]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/lists/followers */
    public func followers(tipID: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/followers"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/items */
    public func items(tipID: String, itemId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/" + itemId
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/saves */
    public func saves(tipID: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/saves"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/suggestphoto */
    public func suggestphoto(tipID: String, itemId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/suggestphoto"
        let parameters = [Parameter.itemId:itemId]
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/suggesttip */
    public func suggesttip(tipID: String, itemId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/suggesttip"
        let parameters = [Parameter.itemId:itemId]
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/suggestvenues */
    public func suggestvenues(tipID: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/suggestvenues"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/lists/additem */
    public func additem(listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/additem"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/deleteitem */
    public func deleteitem(listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/deleteitem"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/follow */
    public func follow(listId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/follow"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/moveitem */
    public func moveitem(listId: String, itemId: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = listId + "/moveitem"
            var allParameters = [Parameter.itemId:itemId]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/share */
    public func share(listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/share"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/unfollow */
    public func unfollow(listId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/unfollow"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/update */
    public func update(listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/update"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/updateitem */
    public func updateitem(listId: String, itemId: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = listId + "/updateitem"
            var allParameters = [Parameter.itemId:itemId]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
}
