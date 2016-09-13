//
//  Result.swift
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
open class Result: CustomStringConvertible {
    
    /** 
        HTTP response status code.
    */
    open var HTTPSTatusCode: Int?
    
    /** 
        HTTP response headers.
        Can contain `RateLimit-Remaining` and `X-RateLimit-Limit`.
        Read about `Rate Limits` <https://developer.foursquare.com/overview/ratelimits>.
    */
    open var HTTPHeaders: [AnyHashable: Any]?
    
    /** 
        The URL which has been requested. 
    */
    open var URL: Foundation.URL?
    
    
    /*
        Can contain error with following error domains:
            QuadratResponseErrorDomain  - in case of error in `meta` parameter of Foursquare response. 
                Error doesn't have localized description, but has `QuadratResponseErrorTypeKey`
                and `QuadratResponseErrorDetailKey` parameters in `userUnfo`.
            NSURLErrorDomain            - in case of some networking problem.
            NSCocoaErrorDomain          - in case of error during JSON parsing.
    */
    open var error: NSError?
    
    /** 
        A response. Extracted from JSON `response` field.
        Can be empty in case of error or `multi` request. 
        If you are doung `multi` request use `subresponses` property
    */
    open var response: [String:AnyObject]?
    
    /** 
        Responses returned from `multi` endpoint. Subresponses never have HTTP headers and status code.
        Extracted from JSON `responses` field.
    */
    open var results: [Result]?
    
    /** 
        A notifications. Extracted from JSON `notifications` field.
    */
    open var notifications: [[String:AnyObject]]?
    
    init() {
        
    }
    
    open var description: String {
        return "Status code: \(HTTPSTatusCode)\nResponse: \(response)\nError: \(error)"
    }
    
}


/** Response creation from HTTP response. */
extension Result {
    
    class func createResult(_ HTTPResponse: HTTPURLResponse?, JSON: [String:AnyObject]?, error: NSError? ) -> Result {
        let result = Result()
        if let error = error {
            result.error = error
            return result
        }
        
        if let HTTPResponse = HTTPResponse {
            result.HTTPHeaders = HTTPResponse.allHeaderFields
            result.HTTPSTatusCode = HTTPResponse.statusCode
            result.URL = HTTPResponse.url
        }
        
        if let JSON = JSON {
            if let meta = JSON["meta"] as? [String:AnyObject], let code = meta["code"] as? Int,
                code < 200 || code > 299 {
                    result.error = NSError(domain: QuadratResponseErrorDomain, code: code, userInfo: meta)
            }
            result.notifications = JSON["notifications"] as? [[String:AnyObject]]
            result.response = JSON["response"] as? [String:AnyObject]
            
            if let response = result.response, let responses = response["responses"] as? [[String:AnyObject]] {
                var subResults = [Result]()
                for aJSONResponse in responses {
                    let quatratResponse = Result.createResult(nil, JSON: aJSONResponse, error: nil)
                    subResults.append(quatratResponse)
                }
                result.results = subResults
                result.response = nil
            }
        }

        return result
    }
    
    class func resultFromURLSessionResponse(_ response: URLResponse?, data: Data?, error: NSError?) -> Result {
        let HTTPResponse = response as? HTTPURLResponse
        var JSONResult: [String: AnyObject]?
        var JSONError = error
        
        if let data = data, JSONError == nil && HTTPResponse?.mimeType == "application/json" {
            do {
                JSONResult = try JSONSerialization.jsonObject(with: data,
                                options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject]
            } catch let error as NSError {
                JSONError = error
            }
        }
        let result = Result.createResult(HTTPResponse, JSON: JSONResult, error: JSONError)
        return result
    }
}

/** Some helpers methods. */
extension Result {
    
    /** Returns `RateLimit-Remaining` parameter, if there is one in `HTTPHeaders`. */
    public func rateLimitRemaining() -> Int? {
        return self.HTTPHeaders?["RateLimit-Remaining"] as? Int
    }
    
    /** Returns `X-RateLimit-Limit` parameter, if there is one in `HTTPHeaders`. */
    public func rateLimit() -> Int? {
        return self.HTTPHeaders?["X-RateLimit-Limit"] as? Int
    }
    
    /** Whether task has been cancelled or not. */
    public func isCancelled() -> Bool {
        if let error = self.error {
            return (error.domain == NSURLErrorDomain  && error.code == NSURLErrorCancelled)
        }
        return false
    }
}
