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
        if (_authorizer != nil) {
            fatalError("You are currently authorizing.")
            return
        }
        
        if (self.canUseNativeOAuth()) {
            _nativeAuthorizer = NativeTouchAuthorizer(configuration: self.configuration)
            _nativeAuthorizer?.authorize()
                {   (accessToken, error) -> Void in
                    //
                    _authorizer = nil
                }
        } else {
            _authorizer = TouchAuthorizer(configuration: self.configuration)
            _authorizer?.authorize(viewController)
                {   (accessToken, error) -> Void in
                    //
                    _authorizer = nil
                }
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

class NativeTouchAuthorizer : Authorizer {
    var configuration : Configuration!
    
     convenience init(configuration: Configuration) {
        let baseURL = configuration.server.nativeOauthBaseURL
        let URLString = String(format: (baseURL + "?client_id=%@&redirect_uri=%@&v=20130509"),
            configuration.client.id, configuration.client.redirectURL)

        let authorizationURL = NSURL(string: URLString)
        let redirectURL = NSURL(string: configuration.client.redirectURL)
        if authorizationURL == nil || redirectURL == nil {
            fatalError("Can't build auhorization URL. Check your clientId and redirectURL")
        }
        self.init(authorizationURL: authorizationURL!, redirectURL: redirectURL!)
        self.configuration = configuration
    }
    
    func authorize(completionHandler: (String?, NSError?) -> Void) {
        self.completionHandler = completionHandler
        UIApplication.sharedApplication().openURL(self.authorizationURL)
    }
    
    func handleURL(URL: NSURL) -> Bool {
        if (URL.scheme == self.redirectURL.scheme) {
            self.didReachRedirectURL(URL)
            return true
        }
        return false
    }
    
    override func didReachRedirectURL(redirectURL: NSURL) {
        let parameters = self.extractParametersFromURL(redirectURL)
        let accessCode = parameters["code"]
        if accessCode != nil {
            // We should exchange access code to access token.
            self.requestAccessTokenWithCode(accessCode!)
        } else {
            // No access code, so we have error there. This method will take care about it.
            super.didReachRedirectURL(redirectURL)
        }
    }
    
    func requestAccessTokenWithCode(code: String) {
        let path = self.configuration.server.nativeOauthAccessTokenBaseURL
        let URLString = String(format: (path + "?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@"),
            self.configuration.client.id, self.configuration.client.secret, self.configuration.client.redirectURL, code)
        let URL = NSURL(string: URLString) as NSURL!
        let request = NSURLRequest(URL: URL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response, data, error) -> Void in
                if data != nil {
                    var parseError: NSError?
                    var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &parseError)
                    if jsonObject != nil && jsonObject!.isKindOfClass(NSDictionary) {
                        let parameters = jsonObject as Parameters
                        self.finilizeAuthorizationWithParameters(parameters)
                    } else {
                        self.finilizeAuthorization(nil, error: parseError)
                    }
                } else {
                    self.finilizeAuthorization(nil, error: error)
                }
        }
    }
}

