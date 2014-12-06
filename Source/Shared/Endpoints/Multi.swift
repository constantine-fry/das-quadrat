//
//  Multi.swift
//  Quadrat
//
//  Created by Constantine Fry on 17/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation


public class Multi: Endpoint {
    override var endpoint   : String {
        return "multi"
    }
    
    /** 
        Returns task to make request to `multi` endpoint.
        Use `subresponses` property of response object.
    */
    public func get(tasks:[Task], completionHandler: ResponseClosure) -> Task {
        let firstTask = tasks.first as Task!
        var queries = [String]()
        for task in tasks {
            let request = task.request
            let path = "/" + request.path.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
            if request.parameters != nil {
                let query = path + makeQuery(request.parameters!)
                queries.append(query)
            } else {
                queries.append(path)
            }
        }
        let queryString = ",".join(queries)
        
        let request =
        Request(baseURL: firstTask.request.baseURL,
            path: self.endpoint,
            parameters: [Parameter.requests:queryString],
            sessionParameters: firstTask.request.sessionParameters,
            HTTPMethod: "POST")
        
        let multiTask = DataTask(session: self.session!, request: request, completionHandler: completionHandler)
        return multiTask
    }
    
    func makeQuery(parameters: Parameters) -> String {
        var query = String()
        for (key,value) in parameters {
            let encodedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
            query += key + "=" + encodedValue! + "&"
        }
        query.removeAtIndex(query.endIndex.predecessor())
        return query
    }
    
}
