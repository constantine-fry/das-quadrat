//
//  Pageupdates.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

open class PageUpdates: Endpoint {
    override var endpoint: String {
        return "pageupdates"
    }
    
    /** https://developer.foursquare.com/docs/pageupdates/pageupdates */
    open func get(_ updateId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(updateId, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/pageupdates/add */
    open func add(_ pageId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = pageId + "/add"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/pageupdates/list */
    open func list(_ completionHandler: ResponseClosure? = nil) -> Task {
        let path = "list"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/pageupdates/delete */
    open func delete(_ updateId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = updateId + "/delete"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/pageupdates/like */
    open func like(_ updateId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = updateId + "/like"
        return self.postWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
}
