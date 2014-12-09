//
//  TouchAuthorizer.swift
//  Quadrat
//
//  Created by Constantine Fry on 12/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit

class TouchAuthorizer : Authorizer {
    var presentingViewController: UIViewController?
    
    func authorize(viewController: UIViewController, completionHandler: (String?, NSError?) -> Void) {
        
        let authorizationViewController = AuthorizationViewController(authorizationURL: authorizationURL, redirectURL: redirectURL, delegate: self)
        authorizationViewController.shouldControllNetworkActivityIndicator = shouldControllNetworkActivityIndicator
        authorizationViewController.delegate = viewController as? AuthorizationViewControllerDelegate

        let navigationController = UINavigationController(rootViewController: authorizationViewController)
        navigationController.modalPresentationStyle = .FormSheet
        viewController.presentViewController(navigationController, animated: true, completion: nil)
        
        self.presentingViewController = viewController
        self.completionHandler = completionHandler
    }
    
    override func finilizeAuthorization(accessToken: String?, error: NSError?) {
        presentingViewController?.dismissViewControllerAnimated(true) {
            self.didDismissViewController(accessToken, error: error)
        }
    }
    
    func didDismissViewController(accessToken: String?, error: NSError?) {
        super.finilizeAuthorization(accessToken, error: error)
    }
    
}
