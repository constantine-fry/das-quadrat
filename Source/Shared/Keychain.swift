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
    
    var logger: Logger?
    
    fileprivate let keychainQuery: [String:AnyObject]
    
    init(configuration: Configuration) {
        #if os(iOS)
            let serviceAttribute = "Foursquare2API-FSKeychain"
        #else
            let serviceAttribute = "Foursquare Access Token"
        #endif
        
        var accountAttribute: String
        if let userTag = configuration.userTag {
            accountAttribute = configuration.client.identifier + "_" + userTag
        } else {
            accountAttribute = configuration.client.identifier
        }
        keychainQuery = [
            kSecClass           as String  : kSecClassGenericPassword,
            kSecAttrAccessible  as String  : kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            kSecAttrService     as String  : serviceAttribute as AnyObject,
            kSecAttrAccount     as String  : accountAttribute as AnyObject
        ]
    }
    
    func accessToken() throws -> String? {
        var query = keychainQuery
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        /** 
            Fixes the issue with Keychain access in release mode.
            https://devforums.apple.com/message/1070614#1070614
        */
        var dataTypeRef: AnyObject? = nil
        let status = withUnsafeMutablePointer(to: &dataTypeRef) {cfPointer -> OSStatus in
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(cfPointer))
        }
        var accessToken: String? = nil
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                if retrievedData.count != 0 {
                    accessToken = NSString(data: retrievedData, encoding: String.Encoding.utf8.rawValue) as? String
                }
            }
        }
        if status != errSecSuccess && status != errSecItemNotFound {
            let error = errorWithStatus(status)
            self.logger?.logError(error, withMessage: "Keychain can't read access token.")
            throw error
        }
        return accessToken
    }
    
    func deleteAccessToken() throws {
        let query = keychainQuery
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            let error = errorWithStatus(status)
            self.logger?.logError(error, withMessage: "Keychain can't delete access token .")
            throw error
        }
    }
    
    func saveAccessToken(_ accessToken: String) throws {
        do {
            if let _ = try self.accessToken() {
                try deleteAccessToken()
            }
        } catch {
            
        }
        var query = keychainQuery
        let accessTokenData = accessToken.data(using: String.Encoding.utf8, allowLossyConversion: false)
        query[kSecValueData as String] =  accessTokenData as AnyObject?
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            let error = errorWithStatus(status)
            self.logger?.logError(error, withMessage: "Keychain can't add access token.")
            throw error
        }
    }
    
    fileprivate func errorWithStatus(_ status: OSStatus) -> NSError {
        return NSError(domain: QuadratKeychainOSSatusErrorDomain, code: Int(status), userInfo: nil)
    }
    
    func allAllAccessTokens() -> [String] {
        return [""]
    }
}
