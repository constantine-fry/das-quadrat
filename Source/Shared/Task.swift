//
//  Task.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public enum FoursquareResponse {
    case Result(Dictionary<String, String>)
    case Error(NSError)
}

public typealias ResponseCompletionHandler = (response: Response) -> Void

public class Task {
    private let task  : NSURLSessionTask?

    init (session: Session, request: NSURLRequest, completionHandler: ResponseCompletionHandler) {
        let URLsession = session.URLSession
        self.task = URLsession.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            self.processResponse(response, data: data, error: error, completionHandler:completionHandler)
        }
    }
    
    init (uploadFromFile:NSURL, session: Session, request: NSURLRequest, completionHandler: ResponseCompletionHandler) {
        let URLsession = session.URLSession
        self.task = URLsession.uploadTaskWithRequest(request, fromFile: uploadFromFile) {
            (data, response, error) -> Void in
            self.processResponse(response, data: data, error: error, completionHandler:completionHandler)
        }
    }
    
    func processResponse(response:NSURLResponse?, data: NSData?, error: NSError?, completionHandler: ResponseCompletionHandler) {
        
        let quatratResponse = Response()
        if let HTTPResponse = response as NSHTTPURLResponse? {
            quatratResponse.HTTPHeaders     = HTTPResponse.allHeaderFields
            quatratResponse.HTTPSTatusCode  = HTTPResponse.statusCode
        }
        quatratResponse.error = error
        
        var result : [String: AnyObject]?
        if data != nil && error == nil {
            var JSONError : NSError?
            let subData = data!.subdataWithRange(NSMakeRange(1, data!.length-10))
            let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(subData, options: NSJSONReadingOptions(0), error: &JSONError)
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
            quatratResponse.notification    = result!["notification"] as [String:AnyObject]?
            quatratResponse.response        = result!["response"] as [String:AnyObject]?
            
        }
        completionHandler(response: quatratResponse)
    }
    
    /** Starts the task. */
    public func start() {
        self.task!.resume()
    }
    
    /** 
        Cancels the task.
        Returns error with NSURLErrorDomain and code NSURLErrorCancelled.
    */
    public func cancel() {
        self.task!.cancel()
    }
}
