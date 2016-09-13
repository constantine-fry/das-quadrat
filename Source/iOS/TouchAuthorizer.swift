//
//  TouchAuthorizer.swift
//  Quadrat
//
//  Created by Constantine Fry on 12/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit

class TouchAuthorizer: Authorizer {
    weak var presentingViewController: UIViewController?
    weak var delegate: SessionAuthorizationDelegate?
    var authorizationViewController: AuthorizationViewController?
    
    func authorize(viewController: UIViewController, delegate: SessionAuthorizationDelegate?,
        completionHandler: @escaping (String?, NSError?) -> Void) {
        
        self.authorizationViewController = AuthorizationViewController(authorizationURL: authorizationURL,
            redirectURL: redirectURL, delegate: self)
        self.authorizationViewController!.shouldControllNetworkActivityIndicator
            = shouldControllNetworkActivityIndicator

        let navigationController = AuthorizationNavigationController(rootViewController: authorizationViewController!)
        navigationController.modalPresentationStyle = .formSheet
        delegate?.sessionWillPresentAuthorizationViewController?(controller: authorizationViewController!)
        viewController.present(navigationController, animated: true, completion: nil)
        
        self.presentingViewController = viewController
        self.completionHandler = completionHandler
        self.delegate = delegate
    }
    
    override func finalizeAuthorization(_ accessToken: String?, error: NSError?) {
        if let authorizationViewController = self.authorizationViewController {
            self.delegate?.sessionWillDismissAuthorizationViewController?(controller: authorizationViewController)
        }
        self.presentingViewController?.dismiss(animated: true) {
            self.didDismissViewController(accessToken: accessToken, error: error)
            self.authorizationViewController = nil
        }
    }
    
    func didDismissViewController(accessToken: String?, error: NSError?) {
        super.finalizeAuthorization(accessToken, error: error)
    }
    
}
