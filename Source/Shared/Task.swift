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



public class Task {
    private var         task               : NSURLSessionTask?
    private weak var    session            : Session?
    private let         completionHandler  : ResponseClosure?
    
    var                 request            : Request
    
    /** The identifier of network activity. */
    var                 networkActivityId  : Int?
    
    init (session: Session, request: Request, completionHandler: ResponseClosure?) {
        self.session = session
        self.request = request
        self.completionHandler = completionHandler
    }
    
    func constructURLSessionTask() {fatalError("Use subclasses!")}
    
    /** Starts the task. */
    public func start() {
        if self.session == nil {
            fatalError("No session for this task.")
        }
        if (self.task == nil) {
            self.constructURLSessionTask()
        }
        if self.task != nil {
            self.task?.resume()
            networkActivityId = session!.networkActivityController?.beginNetworkActivity()
        }
    }
    
    /** 
        Cancels the task.
        Returns error with NSURLErrorDomain and code NSURLErrorCancelled in `completionHandler`.
        Hint: use `isCancelled()` on `Response` object.
    */
    public func cancel() {
        self.task?.cancel()
        self.task = nil
    }
}

class DataTask: Task {
    override func constructURLSessionTask() {
        let URLsession = self.session?.URLSession
        self.task = URLsession?.dataTaskWithRequest(request.URLRequest()) {
            (data, response, error) -> Void in
            self.session?.networkActivityController?.endNetworkActivity(self.networkActivityId)
            
            let result = Result.resultFromURLSessionResponse(response, data: data, error: error)
            self.session?.processResult(result)
            self.session?.completionQueue.addOperationWithBlock {
                self.completionHandler?(result: result)
                return Void()
            }
        }
    }
}

class UploadTask: Task {
    var  fileURL: NSURL?
    
    override func constructURLSessionTask() {
        let mutableRequest = self.request.URLRequest().mutableCopy() as! NSMutableURLRequest
        
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
            self.session?.networkActivityController?.endNetworkActivity(self.networkActivityId)
            
            let result = Result.resultFromURLSessionResponse(response, data: data, error: error)
            self.session?.processResult(result)
            self.session?.completionQueue.addOperationWithBlock {
                self.completionHandler?(result: result)
                return Void()
            }
        }
    }
}
