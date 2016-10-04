//
//  NativeTouchAuthorizer.swift
//  Quadrat
//
//  Created by Constantine Fry on 12/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit

class NativeTouchAuthorizer: Authorizer {
    private var configuration: Configuration!
    
    /** Network activity controller. */
    private var networkActivityController: NetworkActivityIndicatorController?
    
    convenience init(configuration: Configuration) {
        let baseURL = configuration.server.nativeOauthBaseURL
        let parameters = [
            Parameter.client_id    : configuration.client.identifier,
            Parameter.redirect_uri : configuration.client.redirectURL,
            Parameter.v            : "20130509"
        ]
        
        let authorizationURL = Parameter.buildURL(URL(string: baseURL)! as URL, parameters: parameters)
        let redirectURL = URL(string: configuration.client.redirectURL)
        if redirectURL == nil {
            fatalError("Check your redirectURL")
        }
        let keychain = Keychain(configuration: configuration)
        self.init(authorizationURL: authorizationURL, redirectURL: redirectURL! as URL, keychain:keychain)
        self.configuration = configuration
        if configuration.shouldControllNetworkActivityIndicator {
            networkActivityController = NetworkActivityIndicatorController()
        }
    }
    
    func authorize(completionHandler: @escaping (String?, NSError?) -> Void) {
        self.completionHandler = completionHandler
        UIApplication.shared.openURL(self.authorizationURL)
    }
    
    func handleURL(url: URL) -> Bool {
        if url.scheme == self.redirectURL.scheme {
            self.didReachRedirectURL(url)
            return true
        }
        return false
    }
    
    override func didReachRedirectURL(_ redirectURL: URL) {
        let parameters = self.extractParametersFromURL(redirectURL as URL)
        let accessCode = parameters["code"]
        if let accessCode = accessCode {
            // We should exchange access code to access token.
            self.requestAccessTokenWithCode(code: accessCode)
        } else {
            // No access code, so we have error there. This method will take care about it.
            super.didReachRedirectURL(redirectURL)
        }
    }
    
    func requestAccessTokenWithCode(code: String) {
        let accessTokenURL = self.configuration.server.nativeOauthAccessTokenBaseURL
        
        let client = self.configuration.client
        let parameters = [
            Parameter.client_id     : client.identifier,
            Parameter.client_secret : client.secret,
            Parameter.redirect_uri  : client.redirectURL,
            Parameter.code          : code,
            Parameter.grant_type    : "authorization_code"
        ]
        let url = Parameter.buildURL(URL(string: accessTokenURL)!, parameters: parameters)
        let request = URLRequest(url: url)
        let identifier = self.networkActivityController?.beginNetworkActivity()
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            self.networkActivityController?.endNetworkActivity(identifier)
            self.processData(data: data, response: response, error: error as NSError?)
        }
        task.resume()
    }
    
    private func processData(data: Data?, response: URLResponse?, error: NSError?) {
        if let data = data, let response = response, response.mimeType == "application/json" {
            var parseError: NSError?
            var jsonObject: Any? = nil
            do {
                jsonObject = try JSONSerialization.jsonObject(with: data,
                                                              options: JSONSerialization.ReadingOptions(rawValue: 0))
            } catch let error as NSError {
                parseError = error
            }
            OperationQueue.main.addOperation {
                if let parameters = jsonObject as? Parameters {
                    self.finalizeAuthorizationWithParameters(parameters)
                } else {
                    self.finalizeAuthorization(nil, error: parseError)
                }
            }
        } else {
            OperationQueue.main.addOperation {
                self.finalizeAuthorization(nil, error: error)
            }
        }
    }
}
