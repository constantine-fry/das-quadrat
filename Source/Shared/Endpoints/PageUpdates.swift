//
//  Pageupdates.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class PageUpdates: Endpoint {
    override var endpoint: String {
        return "pageupdates"
    }
    
    public func get(updateId: String, parameters: Parameters?, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(updateId, parameters: parameters, completionHandler)
    }
    
    // MARK: - General
    
    // MARK: - Aspects
    
    // MARK: - Actions
}
