//
//  Client.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation


public struct Configuration {
    
    let identintifier   : String
    let secret          : String
    let callbackURL     : NSURL
    let locale          : String
    var accessToken     : String?
    let version         : String = "20140503"
    
    public init(clientID: String, clientSecret: String, callbackURL: String) {
        self.init(clientID: clientID, clientSecret: clientSecret, callbackURL: callbackURL, version: nil, accessToken: nil)
    }
    
    public init(clientID: String, clientSecret: String, callbackURL: String, version: String?, accessToken: String?) {
        self.identintifier = clientID
        self.secret = clientSecret
        self.accessToken = accessToken
        self.callbackURL = NSURL(string: callbackURL) as NSURL!
        self.locale = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as String
        if version != nil {
            self.version = version!
        }
    }
    
    func parameters() -> Parameters {
        var result = Parameters()
        if self.accessToken != nil {
            result["oauth_token"] = self.accessToken
        }
        result["client_id"] = self.identintifier
        result["client_secret"] = self.secret
        result["v"] = self.version
        result["locale"] = self.locale
        return result
    }
}
