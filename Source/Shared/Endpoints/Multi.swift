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
    
    public func get(tasks:[Task], completionHandler: ResponseCompletionHandler) -> Task {
        let firstTask = tasks.first as Task!
        var queries = [String]()
        for task in tasks {
            let request = task.request
            let path = "/" + request.path.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            if request.parameters != nil {
                let query = path + Parameter.makeQuery(request.parameters!)
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
        
        let multiTask = Task(session: self.session!, request: request, completionHandler: completionHandler)
        return multiTask
    }
    
}
