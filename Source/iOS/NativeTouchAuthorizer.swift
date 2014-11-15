//
//  NativeTouchAuthorizer.swift
//  Quadrat
//
//  Created by Constantine Fry on 12/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit

class NativeTouchAuthorizer : Authorizer {
    var configuration : Configuration!
    
    convenience init(configuration: Configuration) {
        let baseURL = configuration.server.nativeOauthBaseURL
        let parameters =
            [Parameter.client_id    : configuration.client.id,
            Parameter.redirect_uri  : configuration.client.redirectURL,
            Parameter.v             : "20130509"]
        
        let URLString = baseURL + "?" + Parameter.makeQuery(parameters)
        let authorizationURL = NSURL(string: URLString)
        let redirectURL = NSURL(string: configuration.client.redirectURL)
        if authorizationURL == nil || redirectURL == nil {
            fatalError("Can't build auhorization URL. Check your clientId and redirectURL")
        }
        let keychain = Keychain(configuration: configuration)
        self.init(authorizationURL: authorizationURL!, redirectURL: redirectURL!, keychain:keychain)
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
        
        let client = self.configuration.client
        let parameters =    
            [Parameter.client_id    : client.id,
            Parameter.client_secret : client.secret,
            Parameter.redirect_uri  : client.redirectURL,
            Parameter.code          : code,
            Parameter.grant_type    : "authorization_code"]
        
        let URLString = path + "?" + Parameter.makeQuery(parameters)
        let URL = NSURL(string: URLString) as NSURL!
        let request = NSURLRequest(URL: URL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response, data, error) -> Void in
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
