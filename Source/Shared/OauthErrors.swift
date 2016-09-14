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
public enum QuadratOauthErrorCode: Int {
    case oauthInvalidRequest        = -999
    case oauthInvalidClient         = -998
    case oauthInvalidGrant          = -997
    case oauthUnauthorizedClient    = -996
    case oauthUnsupportedGrantType  = -995
    case oauthUnknownError          = -994
}

extension NSError {
    
    /** Creates an error from string error returned by Foursquare server. */
    class func quadratOauthErrorForString(_ string: String) -> NSError {
        var code: QuadratOauthErrorCode!
        var description: String!
        
        switch string {
            case "invalid_request":
                code = .oauthInvalidRequest
                description = "Oauth invalid request"
            
            case "invalid_client":
                code = .oauthInvalidClient
                description = "Oauth invalid client"
            
            case "invalid_grant":
                code = .oauthInvalidGrant
                description = "Oauth invalid client"
            
            case "unauthorized_client":
                code = .oauthUnauthorizedClient
                description = "Oauth unauthorized client"
            
            case "unsupported_grant_type":
                code = .oauthUnsupportedGrantType
                description = "Oauth unsupported grant type"
        
            default:
                code = .oauthUnknownError
                description = "Oauth unknown error"
        }
        
        let info = [NSLocalizedDescriptionKey: description, QuadratOauthErrorOriginalStringKey: string]
        return NSError(domain: QuadratOauthErrorDomain, code: code.rawValue, userInfo: info)
    }
}
