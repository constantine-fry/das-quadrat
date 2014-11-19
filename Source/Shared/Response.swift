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
public let QuadratResponseErrorDetailKey = "errorDetail"


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
    
    /** 
        The URL which has been requested. 
    */
    public var URL    : NSURL?
    
    
    /*
        Can contain error with following error domains:
            QuadratResponseErrorDomain  - in case of error in `meta` parameter of Foursquare response. Error doesn't have localized description, but has `QuadratResponseErrorTypeKey` and `QuadratResponseErrorDetailKey` parameters in `userUnfo`.
            NSURLErrorDomain            - in case of some networking problem.
            NSCocoaErrorDomain          - in case of error during JSON parsing.
    */
    public var error          : NSError?
    
    /** 
        A response. Extracted from JSON `response` field.
        Can be empty in case of error or `multi` request. 
        If you are doung `multi` request use `subresponses` property
    */
    public var response       : [String:AnyObject]?
    
    /** 
        Responses returned from `multi` endpoint. Subresponses never have HTTP headers and status code.
        Extracted from JSON `responses` field.
    */
    public var subresponses   : [Response]?
    
    /** 
        A notifications. Extracted from JSON `notifications` field.
    */
    public var notifications   : [String:AnyObject]?
    
    init() {
        
    }
    
}


/** Response creation from HTTP response. */
extension Response {
    
    class func createResponse(HTTPResponse: NSHTTPURLResponse?, JSON: [String:AnyObject]?, error: NSError? ) -> Response {
        let response = Response()
        if HTTPResponse != nil {
            response.HTTPHeaders     = HTTPResponse!.allHeaderFields
            response.HTTPSTatusCode  = HTTPResponse!.statusCode
            response.URL             = HTTPResponse!.URL
        }
        
        if JSON != nil {
            if let meta = JSON!["meta"] as [String:AnyObject]? {
                if let code = meta["code"] as Int? {
                    if code < 200 || code > 299 {
                        response.error = NSError(domain: QuadratResponseErrorDomain, code: code, userInfo: meta)
                    }
                }
            }
            response.notifications   = JSON!["notifications"]   as [String:AnyObject]?
            response.response        = JSON!["response"]        as [String:AnyObject]?
            
            if response.response != nil {
                if let responses = response.response!["responses"] as [[String:AnyObject]]?{
                    var subResponses = [Response]()
                    for aJSONResponse in responses {
                        let quatratResponse = Response.createResponse(nil, JSON: aJSONResponse, error: nil)
                        subResponses.append(quatratResponse)
                    }
                    response.subresponses = subResponses
                    response.response = nil
                }
            }
        }
        
        if error != nil {
            response.error = error
        }
        return response
    }
    
    class func responseFromURLSessionResponse(response:NSURLResponse?, data: NSData?, error: NSError?) -> Response {
        let HTTPResponse = response as NSHTTPURLResponse?
        var JSONResult: [String: AnyObject]?
        var JSONError = error
        
        if data != nil && JSONError == nil {
            let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(0), error: &JSONError)
            if object != nil {
                JSONResult = object as [String: AnyObject]?
            }
        }
        let quatratResponse = Response.createResponse(HTTPResponse, JSON: JSONResult, error: JSONError)
        return quatratResponse
    }
}

/** Same helpers methods. */
extension Response {
    
    /** Returns `RateLimit-Remaining` parameter, if there is one in `HTTPHeaders`. */
    public func rateLimitRemaining() -> Int? {
        return self.HTTPHeaders?["RateLimit-Remaining"] as Int?
    }
    
    /** Returns `X-RateLimit-Limit` parameter, if there is one in `HTTPHeaders`. */
    public func rateLimit() -> Int? {
        return self.HTTPHeaders?["X-RateLimit-Limit"] as Int?
    }
    
    /** Whether task has been cancelled or not. */
    public func isCancelled() -> Bool {
        if self.error != nil {
            return (self.error!.domain == NSURLErrorDomain  && self.error!.code == NSURLErrorCancelled)
        }
        return false
    }
}
