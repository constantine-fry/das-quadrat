//
//  Request.swift
//  Quadrat
//
//  Created by Constantine Fry on 17/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

class Request {
    /** Request parameters. */
    let parameters          : Parameters?
    
    /** Endpoint path. */
    let path                : String
    
    /** HTTP method. POST or GET. */
    let HTTPMethod          : String
    
    /** Sessian wise parameters from configuration. */
    let sessionParameters   : Parameters
    
    /** Should be like this "https://api.foursquare.com/v2". Specified in `Configuration` */
    let baseURL             : NSURL
    
    /** The timeout interval in seconds. */
    var timeoutInterval     : NSTimeInterval = 60
    
    init(baseURL:NSURL, path: String, parameters: Parameters?, sessionParameters:Parameters, HTTPMethod: String) {
        self.baseURL = baseURL
        self.parameters = parameters
        self.sessionParameters = sessionParameters
        self.HTTPMethod = HTTPMethod
        self.path = path
    }
    
    func URLRequest() -> NSURLRequest {
        var allParameters = self.sessionParameters
        if parameters != nil {
            allParameters += parameters!
        }
        let URL = self.baseURL.URLByAppendingPathComponent(self.path)
        let requestURL = Parameter.buildURL(URL, parameters: allParameters)
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = HTTPMethod
        return request
    }
}
