//
//  Task.swift
//  Foursquare
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public enum FoursquareResponse {
    case Result(Dictionary<String, String>)
    case Error(NSError)
}

public typealias ResponseCompletionHandler = (response: AnyObject) -> Void

public class Task {
    private let task  : NSURLSessionTask

    init (session: Session, request: NSURLRequest, completionHandler: ResponseCompletionHandler) {
        let URLsession = session.URLSession
        self.task = URLsession.dataTaskWithRequest(request)
            {
                (data, response, error) -> Void in
                if data != nil {
                    let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    completionHandler(response: result!)
                } else {
                    completionHandler(response: error!)
                }
        }
    }
    
    init (uploadFromFile:NSURL, session: Session, request: NSURLRequest, completionHandler: ResponseCompletionHandler) {
        let URLsession = session.URLSession
        self.task = URLsession.uploadTaskWithRequest(request, fromFile: uploadFromFile)
            {
                (data, response, error) -> Void in
                if data != nil {
                    let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    completionHandler(response: result!)
                } else {
                    completionHandler(response: error!)
                }
        }
    }
    
    public func start() {
        self.task.resume()
    }
    
    public func cancel() {
        self.task.cancel()
    }
}
