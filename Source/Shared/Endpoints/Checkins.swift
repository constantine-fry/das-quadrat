//
//  Checkins.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

open class Checkins: Endpoint {
    override var endpoint: String {
        return "checkins"
    }
    
    /** https://developer.foursquare.com/docs/checkins/checkins */
    open func get(_ checkinId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(checkinId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/checkins/add */
    open func add(_ venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "add"
        var allParameters = [Parameter.venueId:venueId]
        allParameters += parameters
        return self.postWithPath(path, parameters: allParameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/checkins/recent */
    open func recent(_ parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "recent"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/checkins/likes */
    open func likes(_ checkinId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = checkinId + "/likes"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/checkins/addcomment */
    open func addcomment(_ checkinId: String,
        parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
            let path = checkinId + "/addcomment"
            return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/checkins/addpost */
    open func addpost(_ checkinId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = checkinId + "/addpost"
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/checkins/deletecomment */
    open func deletecomment(_ checkinId: String, commentId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = checkinId + "/deletecomment"
        let parameters = [Parameter.commentId:commentId]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/checkins/like */
    open func like(_ checkinId: String, like: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = checkinId + "/like"
        let parameters = [Parameter.set: (like) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
}
