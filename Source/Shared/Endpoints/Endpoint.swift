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
    let configuration   : Configuration
    let baseURL         : NSURL
    weak var session    : Session?
    let keychain        : Keychain
    
    init(configuration: Configuration, session: Session) {
        self.configuration = configuration
        self.session = session
        self.baseURL = NSURL(string: self.configuration.server.apiBaseURL) as NSURL!
        self.keychain = Keychain(configuration: configuration)
    }
    
    func taskWithPath(path: String, parameters: Parameters?, HTTPMethod: String, completionHandler:  ResponseCompletionHandler) -> Task {
        
        let request = self.requestWithPath(path, parameters: parameters, HTTPMethod: HTTPMethod)
        return Task(session:self.session!, request: request, completionHandler)
    }
    
    func uploadTaskFromURL(fromURL: NSURL, path: String, parameters: Parameters?, HTTPMethod: String, completionHandler:  ResponseCompletionHandler) -> Task {
        
        let request = self.requestWithPath(path, parameters: parameters, HTTPMethod: HTTPMethod)
        return Task(uploadFromFile: fromURL, session: self.session!, request: request, completionHandler)
    }
    
    func requestWithPath(path: String, parameters: Parameters?, HTTPMethod: String) -> NSURLRequest {
        let URL = self.baseURL.URLByAppendingPathComponent(path)
        let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false) as NSURLComponents!
        
        var allParameters = self.configuration.parameters()
        if parameters != nil {
            allParameters += parameters!
            if allParameters[Parameter.oauth_token] == nil {
                if let accessToken = self.keychain.accessToken() {
                    allParameters[Parameter.oauth_token] = accessToken
                }
            }
        }
        components.query = Parameter.makeQuery(allParameters)
        let requestURL = components.URL as NSURL!
        let request = NSURLRequest(URL: requestURL)
        return request
    }
    
    public func taskWithRequest(request: NSURLRequest, completionHandler:  ResponseCompletionHandler) -> Task {
        return Task(session:self.session!, request: request, completionHandler)
    }
}
