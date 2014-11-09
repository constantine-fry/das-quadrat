//
//  Authorizer.swift
//  Quadrat
//
//  Created by Constantine Fry on 09/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

protocol AuthorizationDelegate {
    func userDidCancel()
    func didRichRedirectURL(redirectURL: NSURL)
}

class Authorizer: AuthorizationDelegate {
    let redirectURL : NSURL
    let authorizationURL : NSURL
    var completionHandler: ((String?, NSError?) -> Void)?
    
    init(configuration: Configuration) {
        let URLString = String(format: "https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@",
            configuration.identintifier, configuration.callbackURL)
        let URL = NSURL(string: URLString)
        if URL == nil {
            fatalError("Can't build auhorization URL. Check your cliendId and redirectURL")
        }
        self.authorizationURL = URL!
        self.redirectURL = configuration.callbackURL
        self.cleanupCookiesForURL(authorizationURL)
    }
    
    func userDidCancel() {
        let error = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.finilizeAuthorization(nil, error: error)
    }
    
    func didRichRedirectURL(redirectURL: NSURL) {
        println("redirectURL" + redirectURL.absoluteString!)
        let accessToken = ""
        self.finilizeAuthorization(accessToken, error: nil)
    }
    
    func finilizeAuthorization(accessToken: String?, error: NSError?) {
        self.completionHandler?(accessToken, error)
        self.completionHandler = nil
    }
    
    func cleanupCookiesForURL(URL: NSURL) {
        let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if storage.cookies != nil {
            let cookies = storage.cookies as [NSHTTPCookie]
            for cookie in cookies {
                if cookie.domain == URL.host {
                    storage.deleteCookie(cookie as NSHTTPCookie)
                }
            }
        }
    }
}
