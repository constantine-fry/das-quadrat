//
//  Settings.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Settings: Endpoint {
    override var endpoint: String {
        return "settings"
    }
    
    public func get(settingId: String, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(settingId, parameters: nil, completionHandler)
    }
    
    // MARK: - General
    
    // MARK: - Aspects
    
    // MARK: - Actions
}
