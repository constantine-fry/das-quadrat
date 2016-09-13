//
//  Pages.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

open class Pages: Endpoint {
    override var endpoint: String {
        return "pages"
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/pages/add */
    open func add(_ name: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = "add"
        let parameters = [Parameter.name: name]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/pages/managing */
    open func managing(_ completionHandler: ResponseClosure? = nil) -> Task {
        let path = "managing"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - Aspects
    
    /** https://developer.foursquare.com/docs/pages/access */
    open func access(_ userId: String, completionHandler: ResponseClosure? = nil) -> Task {
        let path = userId + "/access"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/pages/similar */
    open func similar(_ userId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = userId + "/similar"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/pages/timeseries */
    open func timeseries(_ pageId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = pageId + "/timeseries"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    /** https://developer.foursquare.com/docs/pages/venues */
    open func venues(_ pageId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        let path = pageId + "/venues"
        return self.getWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
    
    
    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/pages/follow */
    open func follow(_ pageId: String, follow: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = pageId + "/follow"
        let parameters = [Parameter.set: (follow) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }

}
