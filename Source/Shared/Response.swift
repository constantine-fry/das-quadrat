//
//  Response.swift
//  Quadrat
//
//  Created by Constantine Fry on 16/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public let QuadratResponseErrorDomain   = "QuadratOauthErrorDomain"
public let QuadratResponseErrorTypeKey  = "errorType"
public let QuadratResponseErroretailKey = "errorDetail"


/**
    A response from Foursquare server.
    Read `Responses & Errors`:
    https://developer.foursquare.com/overview/responses
*/
public class Response {
    
    /** 
        HTTP response status code.
    */
    public var HTTPSTatusCode : Int?
    
    /** 
        HTTP response headers.
        Can contain `RateLimit-Remaining` and `X-RateLimit-Limit`.
        Read about `Rate Limits` <https://developer.foursquare.com/overview/ratelimits>.
    */
    public var HTTPHeaders    : [NSObject:AnyObject]?
    
    /** The URL which has been requested. */
    public var URL    : NSURL?
    
    
    /*
        Can contain error with following error domains:
            QuadratResponseErrorDomain  - in case of error in `meta` parameter of Foursquare response. Error doesn't have localized description.
            NSURLErrorDomain            - in case of some networking problem.
            NSCocoaErrorDomain          - in case of error during JSON parsing.
    */
    public var error          : NSError?
    public var response       : [String:AnyObject]?
    public var notification   : [String:AnyObject]?
    
    init() {
        
    }
    
    /** Returns `RateLimit-Remaining` parameter, if there is one in `HTTPHeaders`. */
    public func rateLimitRemaining() -> Int? {
        return self.HTTPHeaders?["RateLimit-Remaining"] as Int?
    }
    
    /** Returns `X-RateLimit-Limit` parameter, if there is one in `HTTPHeaders`. */
    public func rateLimit() -> Int? {
        return self.HTTPHeaders?["X-RateLimit-Limit"] as Int?
    }
    
}
