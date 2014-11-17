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
    private var task                    : NSURLSessionTask?
    private weak var session            : Session?
    private let request                 : Request
    private let completionHandler       : ResponseCompletionHandler
    var fileURL                         : NSURL?
    
    init (session: Session, request: Request, completionHandler: ResponseCompletionHandler) {
        self.session = session
        self.request = request
        self.completionHandler = completionHandler
    }
    
    func constructURLSessionTask() {
        if self.fileURL == nil {
            self.constractDataTask()
        } else {
            self.constructFileUploadTask()
        }
    }
    
    func constractDataTask() {
        let URLsession = self.session?.URLSession
        self.task = URLsession?.dataTaskWithRequest(request.URLRequest()) {
            (data, response, error) -> Void in
            self.processResponse(response, data: data, error: error, completionHandler:self.completionHandler)
        }
    }
    
    func constructFileUploadTask() {
        let mutableRequest = request.URLRequest().mutableCopy() as NSMutableURLRequest
        
        let boundary = NSUUID().UUIDString
        let contentType = "multipart/form-data; boundary=" + boundary
        mutableRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        let appendStringBlock = {
            (string: String) in
            body.appendData(string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        }
        var extention = self.fileURL!.pathExtension
        if extention == nil {
            extention = "png"
        }
        appendStringBlock("\r\n--\(boundary)\r\n")
        appendStringBlock("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.\(extention)\"\r\n")
        appendStringBlock("Content-Type: image/\(extention)\r\n\r\n")
        if let imageData = NSData(contentsOfURL: self.fileURL!) {
            body.appendData(imageData)
        } else {
            fatalError("Can't read data at URL: \(self.fileURL!)")
        }
        appendStringBlock("\r\n--\(boundary)--\r\n")
        self.task = self.session?.URLSession.uploadTaskWithRequest(mutableRequest, fromData: body) {
            (data, response, error) -> Void in
            self.processResponse(response, data: data, error: error, completionHandler:self.completionHandler)
        }
    }
    
    func processResponse(response:NSURLResponse?, data: NSData?, error: NSError?, completionHandler: ResponseCompletionHandler) {
        
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
        completionHandler(response: quatratResponse)
    }
    
    /** Starts the task. */
    public func start() {
        if self.session == nil {
            fatalError("No sessin fo this task.")
        }
        if (self.task == nil) {
            self.constructFileUploadTask()
        }
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
