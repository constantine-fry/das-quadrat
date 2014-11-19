//
//  Configuration.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

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

/** 
    Session configuartion.

    Read 'Versioning & Internationalization' for `version`, `mode` and `locale` parameters.
    https://developer.foursquare.com/overview/versioning
*/
public struct Configuration {
    
    /** The Oauth2 specific information of application. */
    let client          : Client
    
    /** The server specific information. */
    let server          : Server = Server()
    
    /** The access token. May be set for some tests. */
    var accessToken     : String?
    
    /** 
        The `v` parameter of API. Global parameter for session.
        Date in format YYYYMMDD.
    */
    public let version         : String = "20140503"
    
    /** 
        The `m` parameter of API. Global parameter for session.
    */
    public let mode            : String = "swarm"
    
    /** 
        The `locale` parameter of API. Global parameter for session.
        Two-letters language code. For example: "en" or "de"
        Default value is system language.
    */
    public let locale          : String
    
    /** The user tag. */
    public var userTag         : String?
    
    /** 
        Creates Configuration with specified client.
        `Mode`      is swarm.
        `Locale`    is system language. (NSLocale.preferredLanguages().first)
        `Version`   is 20141102.
    */
    public init(client: Client) {
        self.init(client: client, version: nil, accessToken: nil)
    }
    
    /** 
        Creates Configuration with specified client.
        @discussion Access token passed in configuration never stored in Keychain.
        The main purpose: create session for some tests classes with hard coded access token.
    */
    public init(client: Client, version: String?, accessToken: String?) {
        self.client = client
        
        let languageCode = NSLocale.preferredLanguages().first as String
        let supportedCodes = ["en", "es", "fr", "de", "it", "ja", "th", "tr", "ko", "ru", "pt", "id"]
        if contains(supportedCodes, languageCode) {
            self.locale = languageCode
        } else {
            self.locale = "en"
        }
        if version != nil {
            self.version = version!
        }
        if accessToken != nil {
            self.accessToken = accessToken
        }
    }
    
    func parameters() -> Parameters {
        var result = [
            Parameter.client_id     : self.client.id,
            Parameter.client_secret : self.client.secret,
            Parameter.v             : self.version,
            Parameter.locale        : self.locale,
            Parameter.m             : self.mode
        ]
        if self.accessToken != nil {
            result[Parameter.oauth_token] = self.accessToken!
        }
        return result
    }
}
