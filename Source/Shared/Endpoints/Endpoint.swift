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
    let configuration : Configuration
    weak var session : Session?
    
    init(configuration: Configuration, session: Session) {
        self.configuration = configuration
        self.session = session
    }
    
    func taskWithPath(path: String, parameters: Parameters?, HTTPMethod: String, completionHandler:  ResponseCompletionHandler) -> Task {
        
        let URL = _baseURL.URLByAppendingPathComponent(path)
        let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false) as NSURLComponents!
        components.query = self.makeQuery(parameters)
        let requestURL = components.URL as NSURL!
        let request = NSURLRequest(URL: requestURL)
        return self.taskWithRequest(request, completionHandler)
    }
    
    func uploadTaskFromURL(fromURL: NSURL, path: String, parameters: Parameters?, HTTPMethod: String, completionHandler:  ResponseCompletionHandler) -> Task {
        
        let URL = _baseURL.URLByAppendingPathComponent(path)
        let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false) as NSURLComponents!
        components.query = self.makeQuery(parameters)
        let requestURL = components.URL as NSURL!
        let request = NSURLRequest(URL: requestURL)
        return Task(uploadFromFile: fromURL, session: self.session!, request: request, completionHandler)
    }
    
    
    public func taskWithRequest(request: NSURLRequest, completionHandler:  ResponseCompletionHandler) -> Task {
        return Task(session:self.session!, request: request, completionHandler)
    }
    
    private func makeQuery(parameters: Parameters?) -> String {
        var query = String()
        var allParameters = self.configuration.parameters()
        allParameters += parameters
        for (key, value) in allParameters {
            query += key + "=" + value + "&"
        }
        query.removeAtIndex(query.endIndex.predecessor())
        return query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }
}
