//
//  FSKeychain.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import Security

/** 
    The error domain for errors returned by `Keychain Service`.
    The `code` property will contain OSStatus. See SecBase.h for error codes.
    The `userInfo` is always nil and there is no localized description provided.
*/
public let QuadratKeychainOSSatusErrorDomain = "QuadratKeychainOSSatusErrorDomain"

class Keychain {
    
    #if os(iOS)
        let serviceAttribute = "Foursquare2API-FSKeychain"
    #else
        let serviceAttribute = "Foursquare Access Token"
    #endif
    
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
    
    func accessToken() -> (String?, NSError?) {
        var query = self.keychainQuery
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne
        var dataTypeRef: Unmanaged<AnyObject>?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        var accessToken: String?
        if status == noErr {
            if let opaque = dataTypeRef?.toOpaque() {
                let accessTokenData = Unmanaged<NSData>.fromOpaque(opaque).takeUnretainedValue()
                accessToken = NSString(data: accessTokenData, encoding: NSUTF8StringEncoding) as String?
            }
        }
        dataTypeRef?.release()
        return (accessToken, self.errorWithStatus(status))
    }
    
    func deleteAccessToken() -> (Bool, NSError?) {
        let query = self.keychainQuery
        let status = SecItemDelete(query)
        return (status != noErr, self.errorWithStatus(status))
    }
    
    func saveAccessToken(accessToken: String) -> (Bool, NSError?) {
        var query = self.keychainQuery
        let (existingAccessToken, _ ) = self.accessToken()
        if existingAccessToken != nil  {
            self.deleteAccessToken()
        }
        let accessTokenData = accessToken.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        query[kSecValueData] =  accessTokenData
        let status = SecItemAdd(query, nil)
        return (status == noErr, self.errorWithStatus(status))
    }
    
    private func errorWithStatus(status: OSStatus) -> NSError? {
        var error: NSError?
        if status != noErr {
            error = NSError(domain: QuadratKeychainOSSatusErrorDomain, code: Int(status), userInfo: nil)
        }
        return error
    }
    
    func allAllAccessTokens() -> [String] {
        return [""]
    }
}
