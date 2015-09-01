//
//  Updates.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Updates: Endpoint {
    override var endpoint: String {
        return "updates"
    }
    
    /** https://developer.foursquare.com/docs/updates/updates */
    public func get(updateId: String, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(updateId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/updates/notifications */
    public func notifications(limit: String?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "notifications"
        var parameters: Parameters?
        if limit != nil {
            parameters = [Parameter.limit:limit!]
        }
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/updates/marknotificationsread */
    public func notifications(highWatermark: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "marknotificationsread"
        let parameters = [Parameter.highWatermark: highWatermark]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
}
