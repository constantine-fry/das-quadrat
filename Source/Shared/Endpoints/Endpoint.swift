//
//  Endpoint.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public func +=<K, V> (inout left: Dictionary<K, V>, right: Dictionary<K, V>?) -> Dictionary<K, V> {
    if right != nil {
        for (k, v) in right! {
            left.updateValue(v, forKey: k)
        }
    }
    return left
}

public class Endpoint  {
    weak    var session         : Session?
    private let baseURL         : NSURL
    
    var endpoint: String {
        return ""
    }
    
    init(session: Session) {
        self.session = session
        self.baseURL = NSURL(string:session.configuration.server.apiBaseURL) as NSURL!
    }
    
    func getWithPath(path: String, parameters: Parameters?, completionHandler:  ResponseClosure?) -> Task {
        return self.taskWithPath(path, parameters: parameters, HTTPMethod: "GET", completionHandler: completionHandler)
    }
    
    func postWithPath(path: String, parameters: Parameters?, completionHandler:  ResponseClosure?) -> Task {
        return self.taskWithPath(path, parameters: parameters, HTTPMethod: "POST", completionHandler: completionHandler)
    }
    
    func uploadTaskFromURL(fromURL: NSURL, path: String,
        parameters: Parameters?, completionHandler:  ResponseClosure?) -> Task {
            let request = self.requestWithPath(path, parameters: parameters, HTTPMethod: "POST")
            let task = UploadTask(session: self.session!, request: request, completionHandler: completionHandler)
            task.fileURL = fromURL
            return task
    }
    
    private func taskWithPath(path: String, parameters: Parameters?,
        HTTPMethod: String, completionHandler:  ResponseClosure?) -> Task {
            let request = self.requestWithPath(path, parameters: parameters, HTTPMethod: HTTPMethod)
            return DataTask(session: self.session!, request: request, completionHandler: completionHandler)
    }
    
    private func requestWithPath(path: String, parameters: Parameters?, HTTPMethod: String) -> Request {
        var sessionParameters = session!.configuration.parameters()
        if sessionParameters[Parameter.oauth_token] == nil {
            do {
                let accessToken = try session!.keychain.accessToken()
                if let accessToken = accessToken  {
                    sessionParameters[Parameter.oauth_token] = accessToken
                }
            } catch {
                
            }
        }
        let request = Request(baseURL: self.baseURL, path: (self.endpoint + "/" + path),
            parameters: parameters, sessionParameters: sessionParameters, HTTPMethod: HTTPMethod)
        request.timeoutInterval = session!.configuration.timeoutInterval
        return request
    }
}
