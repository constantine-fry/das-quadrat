//
//  Specials.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Specials: Endpoint {
    override var endpoint: String {
        return "specials"
    }
    
    public func get(specialId: String, venueId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        var allParameters = [Parameter.venueId:venueId]
        allParameters += parameters
        return self.getWithPath(specialId, parameters: allParameters, completionHandler)
    }
    
    // MARK: - General
    
    // MARK: - Aspects
    
    // MARK: - Actions
}
