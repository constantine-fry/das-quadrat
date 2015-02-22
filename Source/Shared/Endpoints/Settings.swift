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
    
    /** https://developer.foursquare.com/docs/settings/settings */
    public func get(settingId: String, completionHandler: ResponseClosure? = nil) -> Task {
        return self.getWithPath(settingId, parameters: nil, completionHandler: completionHandler)
    }
    
    // MARK: - General
    
    /** https://developer.foursquare.com/docs/settings/all */
    public func all(completionHandler: ResponseClosure? = nil) -> Task {
        let path = "all"
        return self.getWithPath(path, parameters: nil, completionHandler: completionHandler)
    }

    // MARK: - Actions
    
    /** https://developer.foursquare.com/docs/settings/set */
    public func set(settingId: String, value: Bool, completionHandler: ResponseClosure? = nil) -> Task {
        let path = settingId + "/set"
        let parameters = [Parameter.value: (value) ? "1":"0"]
        return self.postWithPath(path, parameters: parameters, completionHandler: completionHandler)
    }
}
