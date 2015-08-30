//
//  Authorizer.swift
//  Quadrat
//
//  Created by Constantine Fry on 09/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

protocol AuthorizationDelegate : class {
    func userDidCancel()
    func didReachRedirectURL(redirectURL: NSURL)
}

class Authorizer: AuthorizationDelegate {
    var redirectURL : NSURL
    var authorizationURL : NSURL
    var completionHandler: ((String?, NSError?) -> Void)?
    let keychain: Keychain
    var shouldControllNetworkActivityIndicator = false
    
    convenience init(configuration: Configuration) {
        let baseURL = configuration.server.oauthBaseURL
        let parameters = [
            Parameter.client_id        : configuration.client.id,
            Parameter.redirect_uri     : configuration.client.redirectURL,
            Parameter.v                : configuration.version,
            Parameter.response_type    : "token"
        ]
        
        let authorizationURL = Parameter.buildURL(NSURL(string: baseURL)!, parameters: parameters)
        let redirectURL = NSURL(string: configuration.client.redirectURL)
        if redirectURL == nil {
            fatalError("There is no redirect URL.")
        }
        let keychain = Keychain(configuration: configuration)
        self.init(authorizationURL: authorizationURL, redirectURL: redirectURL!, keychain: keychain)
        self.shouldControllNetworkActivityIndicator = configuration.shouldControllNetworkActivityIndicator
        self.cleanupCookiesForURL(authorizationURL)
    }
    
    init(authorizationURL: NSURL, redirectURL: NSURL, keychain:Keychain) {
        self.authorizationURL = authorizationURL
        self.redirectURL = redirectURL
        self.keychain = keychain
    }
    
    // MARK: - Delegate methods
    
    func userDidCancel() {
        let error = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.finilizeAuthorization(nil, error: error)
    }
    
    func didReachRedirectURL(redirectURL: NSURL) {
        print("redirectURL" + redirectURL.absoluteString)
        let parameters = self.extractParametersFromURL(redirectURL)
        self.finilizeAuthorizationWithParameters(parameters)
    }
    
    // MARK: - Finilization
    
    func finilizeAuthorizationWithParameters(parameters: Parameters) {
        var error: NSError?
        if let errorString = parameters["error"] {
            error = NSError.quadratOauthErrorForString(errorString)
        }
        self.finilizeAuthorization(parameters["access_token"], error: error)
    }
    
    func finilizeAuthorization(accessToken: String?, error: NSError?) {
        var resultError = error
        var result = accessToken
        if let accessToken = accessToken {
            do {
                try self.keychain.saveAccessToken(accessToken)
            } catch let error as NSError {
                result = nil
                resultError = error
            }
        }
        self.completionHandler?(result, resultError)
        self.completionHandler = nil
    }
    
    // MARK: - Helpers
    
    func cleanupCookiesForURL(URL: NSURL) {
        let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if storage.cookies != nil {
            if let cookies = storage.cookies {
                for cookie in cookies {
                    if cookie.domain == URL.host {
                        storage.deleteCookie(cookie as NSHTTPCookie)
                    }
                }
            }
        }
    }
    
    func extractParametersFromURL(fromURL: NSURL) -> Parameters {
        var queryString: String?
        let components = NSURLComponents(URL: fromURL, resolvingAgainstBaseURL: false)
        if components?.query == nil {
            // If we are here it's was web authorization and we have redirect URL like this:
            // testapp123://foursquare#access_token=ACCESS_TOKEN
            queryString = components?.fragment
        } else {
            // If we are here it's was native iOS authorization and we have redirect URL like this:
            // testapp123://foursquare?access_token=ACCESS_TOKEN
            queryString = fromURL.query
        }
        let parameters = queryString?.componentsSeparatedByString("&")
        var map = Parameters()
        if parameters != nil {
            for string: String in parameters! {
                let keyValue = string.componentsSeparatedByString("=")
                if keyValue.count == 2 {
                    map[keyValue[0]] = keyValue[1]
                }
            }
        }
        return map
    }
    
    func errorForErrorString(errorString: String) -> NSError? {
        return nil
    }
}
