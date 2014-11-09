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
extension Session {
    
    public func authorizeWithViewController(viewController: UIViewController, completionHandler: () -> Void) {
        if (_authorizer != nil) {
            fatalError("You are currently authorizing.")
            return
        }
        
        _authorizer = TouchAuthorizer(configuration: self.configuration)
        _authorizer?.authorize(viewController)
            {   (accessToken, error) -> Void in
                //
                _authorizer = nil
            }
    }
}

class TouchAuthorizer : Authorizer {
    var presentingViewController: UIViewController?
    
    func authorize(viewController: UIViewController, completionHandler: (String?, NSError?) -> Void) {

        let authorizationViewController = AuthorizationViewController(authorizationURL: authorizationURL, redirectURL: redirectURL, delegate: self)
        
        let navigationController = UINavigationController(rootViewController: authorizationViewController)
        navigationController.modalPresentationStyle = .FormSheet
        viewController.presentViewController(navigationController, animated: true, completion: nil)
        
        self.presentingViewController = viewController
        self.completionHandler = completionHandler
    }

    override func finilizeAuthorization(accessToken: String?, error: NSError?) {
        presentingViewController?.dismissViewControllerAnimated(true)
            {
                self.completionHandler?(accessToken, error)
                self.completionHandler = nil
                self.presentingViewController = nil
            }
    }
}

