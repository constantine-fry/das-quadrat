//
//  Authorization.swift
//  Quadrat
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import AppKit


extension Session {
    
    public func authorizeWithViewController(_ window: NSWindow, completionHandler: @escaping AuthorizationHandler) {
        if self.authorizer == nil {
            let authorizer = MacAuthorizer(configuration: self.configuration)
            authorizer.authorize(window) {
                (accessToken, error) -> Void in
                completionHandler(accessToken != nil, error)
                
                // Fixes the crash.
                DispatchQueue.main.async {
                    self.authorizer = nil
                }
            }
            self.authorizer = authorizer
        }
    }
}
