//
//  PhotosEndPoint.swift
//  Quadrat
//
//  Created by Constantine Fry on 30/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Photos : Endpoint {
    override var endpoint   : String {
        return "photos"
    }
    
    /** https://developer.foursquare.com/docs/photos/photos */
    public func get(photoId: String, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(photoId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/photos/add */
    public func add(fromURL: NSURL, parameters: Parameters?, completionHandler:  ResponseClosure? = nil) -> Task {
        let path = "add"
        return self.uploadTaskFromURL(fromURL, path: path, parameters: parameters, completionHandler: completionHandler)
    }

}
