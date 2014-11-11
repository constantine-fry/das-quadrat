//
//  Client.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Parameter {
    // Internal.
    class var client_id       : String { return "client_id" }
    class var client_secret   : String { return "client_secret" }
    class var redirect_uri    : String { return "redirect_uri" }
    class var code            : String { return "code" }
    class var grant_type      : String { return "grant_type" }
    class var oauth_token     : String { return "oauth_token" }
    class var v               : String { return "v" }
    class var locale          : String { return "locale" }
    class var response_type   : String { return "response_type" }
    
    // Public.
    public class var checkinId       : String { return "checkinId" }
    public class var tipId           : String { return "tipId" }
    public class var venueId         : String { return "venueId" }
    public class var pageId          : String { return "pageId" }
    
    
    class func makeQuery(parameters: Parameters) -> String {
        var query = String()
        for (key,value) in parameters {
            query += key + "=" + value + "&"
        }
        query.removeAtIndex(query.endIndex.predecessor())
        return query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }
}


/** Client configuration. */
public struct Client {
    let id : String
    let secret : String
    let redirectURL : String
    
    public init(clientID: String, clientSecret: String, redirectURL: String) {
        self.id = clientID
        self.secret = clientSecret
        self.redirectURL = redirectURL
    }
}

/** Server configuration. */
struct Server {
    
    /** Base URL for all foursquare requests. */
    let apiBaseURL = "https://api.foursquare.com/v2"
    
    /** Base URL to login oauth2 page. */
    let oauthBaseURL = "https://foursquare.com/oauth2/authenticate"
    
    /** Base URL to open Foursquare iOS app for authorization. 
        In response app will get access code, which should be exchange to access token. */
    let nativeOauthBaseURL = "foursquareauth://authorize"
    
    /** Base URL to exchange access code to access token. */
    let nativeOauthAccessTokenBaseURL = "https://foursquare.com/oauth2/access_token"
}

/** Session configuartion. */
public struct Configuration {
    
    let client          : Client
    let server          : Server = Server()
    
    let locale          : String
    var accessToken     : String?
    let version         : String = "20140503"
    
    public init(client: Client) {
        self.init(client: client, version: nil, accessToken: nil)
    }
    
    public init(client: Client, version: String?, accessToken: String?) {
        self.client = client
        let languageCode = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as String
        self.locale = languageCode
        if version != nil {
            self.version = version!
        }
        if accessToken != nil {
            self.accessToken = accessToken
        }
    }
    
    func parameters() -> Parameters {
        var result = [Parameter.client_id:self.client.id,
                        Parameter.client_secret:self.client.secret,
                        Parameter.v: self.version,
                        Parameter.locale:self.locale]
        if self.accessToken != nil {
            result[Parameter.oauth_token] = self.accessToken!
        }
        return result
    }
}
