//
//  Authorization.swift
//  Quadrat
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import AppKit

var _authorizer : MacAuthorizer?
extension Session {
    
    public func authorizeWithViewController(window: NSWindow, completionHandler: () -> Void) {
        if (_authorizer != nil) {
            fatalError("You are currently authorizing.")
            return
        }
        
        _authorizer = MacAuthorizer(configuration: self.configuration)
        _authorizer?.authorize(window, completionHandler: { (accessToken, error) -> Void in
            //
            _authorizer = nil
        })
    }
}
