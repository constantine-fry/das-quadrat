//
//  Lists.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

open class Lists: Endpoint {
    override var endpoint: String {
        return "lists"
    }
    
    /** https://developer.foursquare.com/docs/lists/lists */
    open func get(_ listId: String, parameters: Parameters?,
        completionHandler: ResponseClosure? = nil) -> Task {
            return self.getWithPath(listId, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/lists/add */
    open func add(_ name: String, text: String, parameters: Parameters?,
        completionHandler: ResponseClosure? = nil) -> Task {
            let path = "add"
            var allParameters = [Parameter.name:name, Parameter.text:text]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/lists/followers */
    open func followers(_ tipID: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/followers"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/items */
    open func items(_ tipID: String, itemId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/" + itemId
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/saves */
    open func saves(_ tipID: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/saves"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/suggestphoto */
    open func suggestphoto(_ tipID: String, itemId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/suggestphoto"
        let parameters = [Parameter.itemId:itemId]
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/suggesttip */
    open func suggesttip(_ tipID: String, itemId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/suggesttip"
        let parameters = [Parameter.itemId:itemId]
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/suggestvenues */
    open func suggestvenues(_ tipID: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = tipID + "/suggestvenues"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/lists/additem */
    open func additem(_ listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/additem"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/deleteitem */
    open func deleteitem(_ listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/deleteitem"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/follow */
    open func follow(_ listId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/follow"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/moveitem */
    open func moveitem(_ listId: String, itemId: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = listId + "/moveitem"
            var allParameters = [Parameter.itemId:itemId]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/share */
    open func share(_ listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/share"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/unfollow */
    open func unfollow(_ listId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/unfollow"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/update */
    open func update(_ listId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = listId + "/update"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/lists/updateitem */
    open func updateitem(_ listId: String, itemId: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = listId + "/updateitem"
            var allParameters = [Parameter.itemId:itemId]
            allParameters += parameters
            return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
}
