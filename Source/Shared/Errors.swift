//
//  Errors.swift
//  Quadrat
//
//  Created by Constantine Fry on 12/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

let QuadratErrorDomain = "QuadratErrorDomain"

let QuadratErrorOriginalString = "QuadratErrorOriginalString"

enum QuadratErrorCode : Int {
    case UnknownError = -1000
    
    case OauthInvalidRequest = -999
    case OauthInvalidClient = -998
    case OauthInvalidGrant = -997
    case OauthUnauthorizedClient = -996
    case OauthUnsupportedGrantType = -995
}

extension NSError {
    class func quadratErrorForString(string: String) -> NSError {
        var code : QuadratErrorCode!
        var description : String!
        
        switch string {
            case "invalid_request":
                code = .OauthInvalidRequest
                description = "Invalid request"
            
            case "invalid_client":
                code = .OauthInvalidClient
                description = "Invalid client"
            
            case "invalid_grant":
                code = .OauthInvalidGrant
                description = "Invalid client"
            
            case "unauthorized_client":
                code = .OauthUnauthorizedClient
                description = "Unauthorized client"
            
            case "unsupported_grant_type":
                code = .OauthUnsupportedGrantType
                description = "Unsupported grant type"
        
            default:
                code = .UnknownError
                description = "Unknown Error"
        }
        
        let info = [NSLocalizedDescriptionKey:description, QuadratErrorOriginalString: string ]
        return NSError(domain: QuadratErrorDomain, code: code.rawValue, userInfo: info)
    }
}
