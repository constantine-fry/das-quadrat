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
    
    public func get(listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(listId, parameters: parameters, completionHandler)
    }
    
    // MARK: - General
    
    // add
    public func add(name: String, text: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "add"
        var allParameters = [Parameter.name:name]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler)
    }
    
    // MARK: - Aspects
    
    // followers
    public func followers(tipID: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/followers"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // items
    public func items(tipID: String, itemId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/" + itemId
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // saves
    public func saves(tipID: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/saves"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // suggestphoto
    public func suggestphoto(tipID: String, itemId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/suggestphoto"
        let parameters = [Parameter.itemId:itemId]
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // suggesttip
    public func suggesttip(tipID: String, itemId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/suggesttip"
        let parameters = [Parameter.itemId:itemId]
        return self.getWithPath(path, parameters: parameters, completionHandler)
    }
    
    // suggestvenues
    public func suggestvenues(tipID: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/suggestvenues"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // MARK: - Actions
    
    // additem
    public func additem(listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/additem"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // deleteitem
    public func deleteitem(listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/deleteitem"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // follow
    public func follow(listId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/follow"
        return self.postWithPath(path, parameters: nil, completionHandler)
    }
    
    // moveitem
    public func moveitem(listId: String, itemId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/moveitem"
        var allParameters = [Parameter.itemId:itemId]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler)
    }
    
    // share
    public func share(listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/share"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // unfollow
    public func unfollow(listId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/unfollow"
        return self.postWithPath(path, parameters: nil, completionHandler)
    }
    
    // update
    public func update(listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/update"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // updateitem
    public func updateitem(listId: String, itemId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/updateitem"
        var allParameters = [Parameter.itemId:itemId]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler)
    }
}
