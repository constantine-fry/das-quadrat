//
//  Pageupdates.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class PageUpdates: Endpoint {
    override var endpoint: String {
        return "pageupdates"
    }
    
    public func get(updateId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(updateId, parameters: parameters, completionHandler)
    }
    
    // MARK: - General
    
    // add
    public func add(pageId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = pageId + "/add"
        return self.postWithPath(path, parameters: parameters, completionHandler)
    }
    
    // list
    public func list(completionHandler: ResponseClosure? = nil) -> Task {
        let path = "list"
        return self.getWithPath(path, parameters: nil, completionHandler)
    }
    
    // MARK: - Actions
    
    // delete
    public func delete(updateId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = updateId + "/delete"
        return self.postWithPath(path, parameters: nil, completionHandler)
    }
    
    // like
    public func like(updateId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = updateId + "/like"
        return self.postWithPath(path, parameters: nil, completionHandler)
    }
}
