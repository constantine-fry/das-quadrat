//
//  FSKeychain.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation


class Keychain {
    
    func accessToken() -> String {
        return ""
    }
    
    func accessTokenForUserWithTag(tag: String) -> String {
        return ""
    }
    
    func storeAccessToken(accessToken: String, tag: String) -> Bool {
        return true
    }
    
    func allAllAccessTokens() -> [String] {
        return [""]
    }
}
