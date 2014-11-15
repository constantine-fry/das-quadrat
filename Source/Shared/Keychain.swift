//
//  FSKeychain.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import Security

class Keychain {
    let serviceAttribute = "Foursquare2API-FSKeychain"
    let account: String
    let keychainQuery: [String:AnyObject]
    
    init(configuration: Configuration) {
        if let userTag = configuration.userTag {
            self.account = configuration.client.id + "_" + configuration.userTag!
        } else {
            self.account = configuration.client.id
        }
        self.keychainQuery = [
            kSecClass           : kSecClassGenericPassword,
            kSecAttrAccessible  : kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            kSecAttrService     : self.serviceAttribute,
            kSecAttrAccount     : self.account
        ]
    }
    
    func accessToken() -> String? {
        var query = self.keychainQuery
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne
        var dataTypeRef: Unmanaged<AnyObject>?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        var accessToken : String?
        if status == noErr {
            if let opaque = dataTypeRef?.toOpaque() {
                let accessTokenData = Unmanaged<NSData>.fromOpaque(opaque).takeUnretainedValue()
                accessToken = NSString(data: accessTokenData, encoding: NSUTF8StringEncoding) as String?
            }
        }
        dataTypeRef?.release()
        return accessToken
    }
    
    func deleteAccessToken() {
        let query = self.keychainQuery
        let status = SecItemDelete(query)
    }
    
    func saveAccessToken(accessToken: String) -> Bool {
        var query = self.keychainQuery
        if let accesToken = self.accessToken()  {
            self.deleteAccessToken()
        }
        let accessTokenData = accessToken.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        query[kSecValueData] =  accessTokenData
        let status = SecItemAdd(query, nil)
        return status == noErr
    }
    
    func allAllAccessTokens() -> [String] {
        return [""]
    }
}
