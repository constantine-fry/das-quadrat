//
//  Errors.swift
//  Quadrat
//
//  Created by Constantine Fry on 12/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public let QuadratOauthErrorDomain = "QuadratOauthErrorDomain"
public let QuadratOauthErrorOriginalStringKey = "QuadratErrorOriginalString"

/** Oauth errors. */
public enum QuadratOauthErrorCode : Int {
    case OauthInvalidRequest        = -999
    case OauthInvalidClient         = -998
    case OauthInvalidGrant          = -997
    case OauthUnauthorizedClient    = -996
    case OauthUnsupportedGrantType  = -995
    case OauthUnknownError          = -994
}

extension NSError {
    
    /** Creates an error from string error returned by Foursquare server. */
    class func quadratOauthErrorForString(string: String) -> NSError {
        var code : QuadratOauthErrorCode!
        var description : String!
        
        switch string {
            case "invalid_request":
                code = .OauthInvalidRequest
                description = "Oauth invalid request"
            
            case "invalid_client":
                code = .OauthInvalidClient
                description = "Oauth invalid client"
            
            case "invalid_grant":
                code = .OauthInvalidGrant
                description = "Oauth invalid client"
            
            case "unauthorized_client":
                code = .OauthUnauthorizedClient
                description = "Oauth unauthorized client"
            
            case "unsupported_grant_type":
                code = .OauthUnsupportedGrantType
                description = "Oauth unsupported grant type"
        
            default:
                code = .OauthUnknownError
                description = "Oauth unknown error"
        }
        
        let info = [NSLocalizedDescriptionKey:description, QuadratOauthErrorOriginalStringKey: string]
        return NSError(domain: QuadratOauthErrorDomain, code: code.rawValue, userInfo: info)
    }
}
