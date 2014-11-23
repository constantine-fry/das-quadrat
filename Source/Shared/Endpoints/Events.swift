//
//  Events.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Events: Endpoint {
    override var endpoint: String {
        return "events"
    }
    
    public func get(eventId: String, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(eventId, parameters: nil, completionHandler)
    }
    
    // MARK: - General
    
    // MARK: - Aspects
    
    // MARK: - Actions
}
