//
//  Multi.swift
//  Quadrat
//
//  Created by Constantine Fry on 17/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

func encodeURIComponent(_ string: String) -> String {
    return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
}

open class Multi: Endpoint {
    override var endpoint: String {
        return "multi"
    }
    
    /** 
        Returns task to make request to `multi` endpoint.
        Use `subresponses` property of response object.
    */
    open func get(_ tasks: [Task], completionHandler: @escaping ResponseClosure) -> Task {
        let firstTask = tasks.first as Task!
        var queries = [String]()
        for task in tasks {
            let request = task.request
            var path = "/" + request.path
            if let params = request.parameters {
                path = path + "?" + makeQuery(params)
            }
          
            queries.append(path)
        }
        let queryString = encodeURIComponent(queries.joined(separator: ","))
        
        let request =
        Request(baseURL: (firstTask?.request.baseURL)!,
            path: self.endpoint,
            parameters: nil,
            sessionParameters: (firstTask?.request.sessionParameters)!,
            HTTPMethod: "POST",
            preformattedQueryString: "requests=\(queryString)"
        )
        
        let multiTask = DataTask(session: self.session!, request: request, completionHandler: completionHandler)
        return multiTask
    }
    
    func makeQuery(_ parameters: Parameters) -> String {
        var query = String()
        for (key, value) in parameters {
            let encodedValue = encodeURIComponent(value)
            query += key + "=" + encodedValue + "&"
        }
        query.remove(at: query.characters.index(before: query.endIndex))
        return query
    }
    
}
