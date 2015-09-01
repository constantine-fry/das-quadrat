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
    weak var presentingViewController: UIViewController?
    weak var delegate: SessionAuthorizationDelegate?
    var authorizationViewController: AuthorizationViewController?
    
    func authorize(viewController: UIViewController, delegate: SessionAuthorizationDelegate?,
        completionHandler: (String?, NSError?) -> Void) {
        
        authorizationViewController = AuthorizationViewController(authorizationURL: authorizationURL,
            redirectURL: redirectURL, delegate: self)
        authorizationViewController!.shouldControllNetworkActivityIndicator = shouldControllNetworkActivityIndicator

        let navigationController = AuthorizationNavigationController(rootViewController: authorizationViewController!)
        navigationController.modalPresentationStyle = .FormSheet
        delegate?.sessionWillPresentAuthorizationViewController?(authorizationViewController!)
        viewController.presentViewController(navigationController, animated: true, completion: nil)
        
        self.presentingViewController = viewController
        self.completionHandler = completionHandler
        self.delegate = delegate
    }
    
    override func finilizeAuthorization(accessToken: String?, error: NSError?) {
        if authorizationViewController != nil {
            delegate?.sessionWillDismissAuthorizationViewController?(authorizationViewController!)
        }
        presentingViewController?.dismissViewControllerAnimated(true) {
            self.didDismissViewController(accessToken, error: error)
            self.authorizationViewController = nil
        }
    }
    
    func didDismissViewController(accessToken: String?, error: NSError?) {
        super.finilizeAuthorization(accessToken, error: error)
    }
    
}
