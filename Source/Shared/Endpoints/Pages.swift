//
//  Pages.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Pages: Endpoint {
    override var endpoint: String {
        return "pages"
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/pages/add */
    public func add(name: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "add"
        let parameters = [Parameter.name: name]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/pages/managing */
    public func managing(completionHandler: ResponseClosure? = nil) -> Task {
        let path = "managing"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/pages/access */
    public func access(userId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = userId + "/access"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/pages/similar */
    public func similar(userId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = userId + "/similar"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/pages/timeseries */
    public func timeseries(pageId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = pageId + "/timeseries"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/pages/venues */
    public func venues(pageId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = pageId + "/venues"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/pages/follow */
    public func follow(pageId: String, follow: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = pageId + "/follow"
        let parameters = [Parameter.set: (follow) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }

}
