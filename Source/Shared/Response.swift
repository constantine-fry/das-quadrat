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
    
    class func responseFromURLSessionResponse(response:NSURLResponse?, data: NSData?, error: NSError?) -> Response {
        let quatratResponse = Response()
        if let HTTPResponse = response as NSHTTPURLResponse? {
            quatratResponse.HTTPHeaders     = HTTPResponse.allHeaderFields
            quatratResponse.HTTPSTatusCode  = HTTPResponse.statusCode
            quatratResponse.URL             = HTTPResponse.URL
        }
        quatratResponse.error = error
        
        var result : [String: AnyObject]?
        if data != nil && error == nil {
            var JSONError : NSError?
            let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(0), error: &JSONError)
            if object != nil {
                result = object as [String: AnyObject]?
            } else {
                quatratResponse.error = JSONError
            }
        }
        
        if result != nil {
            if let meta = result!["meta"] as [String:AnyObject]? {
                if let code = meta["code"] as Int? {
                    if code < 200 || code > 299 {
                        quatratResponse.error = NSError(domain: QuadratResponseErrorDomain, code: code, userInfo: meta)
                    }
                }
            }
            quatratResponse.notification    = result!["notification"]   as [String:AnyObject]?
            quatratResponse.response        = result!["response"]       as [String:AnyObject]?
            
        }
        return quatratResponse
    }
}
