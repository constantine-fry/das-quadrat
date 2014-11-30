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
    let keychainQuery: [String:AnyObject]
    
    init(configuration: Configuration) {
        #if os(iOS)
            let serviceAttribute = "Foursquare2API-FSKeychain"
            #else
            let serviceAttribute = "Foursquare Access Token"
        #endif
        
        var accountAttribute: String
        if let userTag = configuration.userTag {
            accountAttribute = configuration.client.id + "_" + configuration.userTag!
        } else {
            accountAttribute = configuration.client.id
        }
        keychainQuery = [
            kSecClass           : kSecClassGenericPassword,
            kSecAttrAccessible  : kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            kSecAttrService     : serviceAttribute,
            kSecAttrAccount     : accountAttribute
        ]
    }
    
    func accessToken() -> (String?, NSError?) {
        var query = keychainQuery
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne
        var dataTypeRef: AnyObject? = nil
        /** 
            Fixes the issue with Keychain access in release mode.
            https://devforums.apple.com/message/1070614#1070614
        */
        let status = withUnsafeMutablePointer(&dataTypeRef) {cfPointer -> OSStatus in
            SecItemCopyMatching(query, UnsafeMutablePointer(cfPointer))
        }
        var accessToken: String? = nil
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as NSData? {
                if retrievedData.length != 0 {
                    accessToken = NSString(data: retrievedData, encoding: NSUTF8StringEncoding)
                }
            }
        }
        return (accessToken, errorWithStatus(status))
    }
    
    func deleteAccessToken() -> (Bool, NSError?) {
        let query = keychainQuery
        let status = SecItemDelete(query)
        return (status != errSecSuccess, errorWithStatus(status))
    }
    
    func saveAccessToken(accessToken: String) -> (Bool, NSError?) {
        var query = keychainQuery
        
        let (existingAccessToken, _ ) = self.accessToken()
        if existingAccessToken  != nil {
            deleteAccessToken()
        }
        
        let accessTokenData = accessToken.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        query[kSecValueData] =  accessTokenData
        let status = SecItemAdd(query, nil)
        return (status == errSecSuccess, errorWithStatus(status))
    }
    
    private func errorWithStatus(status: OSStatus) -> NSError? {
        var error: NSError?
        if status != errSecSuccess && status != errSecItemNotFound {
            error = NSError(domain: QuadratKeychainOSSatusErrorDomain, code: Int(status), userInfo: nil)
        }
        return error
    }
    
    func allAllAccessTokens() -> [String] {
        return [""]
    }
}
