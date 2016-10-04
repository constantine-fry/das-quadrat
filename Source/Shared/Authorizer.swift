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
    func didReachRedirectURL(_ redirectURL: URL)
}

class Authorizer: AuthorizationDelegate {
    var redirectURL: URL
    var authorizationURL: URL
    var completionHandler: ((String?, NSError?) -> Void)?
    let keychain: Keychain
    var shouldControllNetworkActivityIndicator = false
    
    convenience init(configuration: Configuration) {
        let baseURL = configuration.server.oauthBaseURL
        let parameters = [
            Parameter.client_id        : configuration.client.identifier,
            Parameter.redirect_uri     : configuration.client.redirectURL,
            Parameter.v                : configuration.version,
            Parameter.response_type    : "token"
        ]
        
        let authorizationURL = Parameter.buildURL(URL(string: baseURL)!, parameters: parameters)
        let redirectURL = URL(string: configuration.client.redirectURL)
        if redirectURL == nil {
            fatalError("There is no redirect URL.")
        }
        let keychain = Keychain(configuration: configuration)
        self.init(authorizationURL: authorizationURL, redirectURL: redirectURL!, keychain: keychain)
        self.shouldControllNetworkActivityIndicator = configuration.shouldControllNetworkActivityIndicator
        self.cleanupCookiesForURL(authorizationURL)
    }
    
    init(authorizationURL: URL, redirectURL: URL, keychain: Keychain) {
        self.authorizationURL = authorizationURL
        self.redirectURL = redirectURL
        self.keychain = keychain
    }
    
    // MARK: - Delegate methods
    
    func userDidCancel() {
        let error = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.finalizeAuthorization(nil, error: error)
    }
    
    func didReachRedirectURL(_ redirectURL: URL) {
        let parameters = self.extractParametersFromURL(redirectURL)
        self.finalizeAuthorizationWithParameters(parameters)
    }
    
    // MARK: - Finilization
    
    func finalizeAuthorizationWithParameters(_ parameters: Parameters) {
        var error: NSError?
        if let errorString = parameters["error"] {
            error = NSError.quadratOauthErrorForString(errorString)
        }
        self.finalizeAuthorization(parameters["access_token"], error: error)
    }
    
    func finalizeAuthorization(_ accessToken: String?, error: NSError?) {
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
    
    func cleanupCookiesForURL(_ URL: Foundation.URL) {
        let storage = HTTPCookieStorage.shared
        storage.cookies?.forEach {
            (cookie) -> () in
            if cookie.domain == URL.host {
                storage.deleteCookie(cookie)
            }
        }
    }
    
    func extractParametersFromURL(_ fromURL: URL) -> Parameters {
        var queryString: String?
        let components = URLComponents(url: fromURL, resolvingAgainstBaseURL: false)
        if components?.query == nil {
            // If we are here it's was web authorization and we have redirect URL like this:
            // testapp123://foursquare#access_token=ACCESS_TOKEN
            queryString = components?.fragment
        } else {
            // If we are here it's was native iOS authorization and we have redirect URL like this:
            // testapp123://foursquare?access_token=ACCESS_TOKEN
            queryString = fromURL.query
        }
        let parameters = queryString?.components(separatedBy: "&")
        var map = Parameters()
        parameters?.forEach {
            let keyValue = $0.components(separatedBy: "=")
            if keyValue.count == 2 {
                map[keyValue[0]] = keyValue[1]
            }
        }
        return map
    }
    
    func errorForErrorString(_ errorString: String) -> NSError? {
        return nil
    }
}
