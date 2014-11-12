//
//  Authorization.swift
//  QuadratTouch
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit

var _authorizer : TouchAuthorizer?
var _nativeAuthorizer : NativeTouchAuthorizer?
extension Session {
    
    public func canUseNativeOAuth() -> Bool {
        let baseURL = self.configuration.server.nativeOauthBaseURL
        let URL = NSURL(string: baseURL) as NSURL!
        return UIApplication.sharedApplication().canOpenURL(URL)
    }
    
    public func handleURL(URL: NSURL) -> Bool {
        if _nativeAuthorizer == nil {
            let nativeAuthorizer = NativeTouchAuthorizer(configuration: self.configuration)
            return nativeAuthorizer.handleURL(URL)
        }
        return _nativeAuthorizer?.handleURL(URL) as Bool!
    }
    
    public func authorizeWithViewController(viewController: UIViewController, completionHandler: () -> Void) {
        if (_authorizer != nil || _nativeAuthorizer != nil) {
            fatalError("You are currently authorizing.")
            return
        }
        
        let completionHandler = { (accessToken, error) -> Void in
            _authorizer = nil
            _nativeAuthorizer = nil
        } as (String?, NSError?) -> Void
        
        if (self.canUseNativeOAuth()) {
            _nativeAuthorizer = NativeTouchAuthorizer(configuration: self.configuration)
            _nativeAuthorizer?.authorize(completionHandler)
        } else {
            _authorizer = TouchAuthorizer(configuration: self.configuration)
            _authorizer?.authorize(viewController, completionHandler: completionHandler)
        }
    }
}
