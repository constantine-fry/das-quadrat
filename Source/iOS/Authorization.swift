//
//  Authorization.swift
//  QuadratTouch
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit

/** The delegate of authorization view controller. */
@objc public protocol SessionAuthorizationDelegate: class {
    
    /** It can be useful if one needs 1password integration. */
    @objc optional func sessionWillPresentAuthorizationViewController(controller: AuthorizationViewController)
    
    @objc optional func sessionWillDismissAuthorizationViewController(controller: AuthorizationViewController)
}

extension Session {
    
    public func canUseNativeOAuth() -> Bool {
        let baseURL = self.configuration.server.nativeOauthBaseURL
        if let url = URL(string: baseURL) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    public func handleURL(url: URL) -> Bool {
        if let nativeAuthorizer = self.authorizer as? NativeTouchAuthorizer {
           return nativeAuthorizer.handleURL(url: url) as Bool!
        }
        let nativeAuthorizer = NativeTouchAuthorizer(configuration: self.configuration)
        return nativeAuthorizer.handleURL(url: url) as Bool!
    }
    
    public func authorizeWithViewController(viewController: UIViewController,
        delegate: SessionAuthorizationDelegate?, completionHandler: @escaping AuthorizationHandler) {
            
        if self.authorizer == nil {
            let block = {
                (accessToken: String?, error: NSError?) -> Void in
                self.authorizer = nil
                completionHandler(accessToken != nil, error)
            }
            
            if self.canUseNativeOAuth() {
                let nativeAuthorizer = NativeTouchAuthorizer(configuration: self.configuration)
                nativeAuthorizer.authorize(completionHandler: block)
                self.authorizer = nativeAuthorizer
            } else {
                let touchAuthorizer = TouchAuthorizer(configuration: self.configuration)
                touchAuthorizer.authorize(viewController: viewController, delegate: delegate, completionHandler: block)
                self.authorizer = touchAuthorizer
            }
        }

    }
}
