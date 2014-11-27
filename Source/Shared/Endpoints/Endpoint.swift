//
//  Endpoint.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

func +=<K, V> (inout left: Dictionary<K, V>, right: Dictionary<K, V>?) -> Dictionary<K, V> {
    if right != nil {
        for (k, v) in right! {
            left.updateValue(v, forKey: k)
        }
    }
    return left
}

public class Endpoint  {
    private let configuration   : Configuration
    weak    var session         : Session?
    private let baseURL         : NSURL
    private let keychain        : Keychain
    
    var endpoint: String {
        return ""
    }
    
    init(configuration: Configuration, session: Session) {
        self.configuration = configuration
        self.session = session
        self.baseURL = NSURL(string:configuration.server.apiBaseURL) as NSURL!
        self.keychain = Keychain(configuration: configuration)
    }
    
    func getWithPath(path: String, parameters: Parameters?, completionHandler:  ResponseClosure?) -> Task {
        return self.taskWithPath(path, parameters: parameters, HTTPMethod: "GET", completionHandler: completionHandler)
    }
    
    func postWithPath(path: String, parameters: Parameters?, completionHandler:  ResponseClosure?) -> Task {
        return self.taskWithPath(path, parameters: parameters, HTTPMethod: "POST", completionHandler: completionHandler)
    }
    
    func uploadTaskFromURL(fromURL: NSURL, path: String, parameters: Parameters?, completionHandler:  ResponseClosure?) -> Task {
        
        let request = self.requestWithPath(path, parameters: parameters, HTTPMethod: "POST")
        let task = UploadTask(session: self.session!, request: request, completionHandler)
        task.fileURL = fromURL
        return task
    }
    
    private func taskWithPath(path: String, parameters: Parameters?, HTTPMethod: String, completionHandler:  ResponseClosure?) -> Task {
        let request = self.requestWithPath(path, parameters: parameters, HTTPMethod: HTTPMethod)
        return DataTask(session: self.session!, request: request, completionHandler: completionHandler)
    }
    
    private func requestWithPath(path: String, parameters: Parameters?, HTTPMethod: String) -> Request {
        var sessionParameters = self.configuration.parameters()
        if sessionParameters[Parameter.oauth_token] == nil {
            if let accessToken = self.keychain.accessToken() {
                sessionParameters[Parameter.oauth_token] = accessToken
            }
        }
        let request = Request(baseURL: self.baseURL, path: (self.endpoint + "/" + path), parameters: parameters, sessionParameters: sessionParameters, HTTPMethod: HTTPMethod)
        request.timeoutInterval = self.configuration.timeoutInterval
        return request
    }
}
