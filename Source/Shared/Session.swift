//
//  FSSession.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

/** A handler used for authorization. */
public typealias AuthorizationHandler = (Bool, NSError?) -> Void

/** A nandler used by all endpoints. */
public typealias ResponseClosure = (response: Response) -> Void

/** A nandler for downloading images. */
public typealias DownloadImageClosure = (imageData: NSData?, error: NSError?) -> Void

/** Typealias for parameters dictionary. */
public typealias Parameters = [String:String]

/**
    Posted when session have access token, but server returns response with 401 HTTP code.
    Guaranteed to be posted an main thread.
*/
public let QuadratSessionDidBecomeUnauthorizedNotification = "QuadratSessionDidBecomeUnauthorizedNotification"

private var _sharedSession : Session?

public class Session {
    let configuration       : Configuration
    let URLSession          : NSURLSession
    var authorizer          : Authorizer?
    let dataCache           : DataCache
    /**
        One can create custom logger to process all errors and responses in one place.
        Main purpose is to debug or to track all the errors accured in framework via some analytic tool.
    */
    public var logger       : Logger?
    
    public lazy var users : Users = {
        return Users(session: self)
        }()
    
    public lazy var venues : Venues = {
        return Venues(session: self)
        }()
    
    public lazy var venueGroups : VenueGroups = {
        return VenueGroups(session: self)
        }()
    
    public lazy var checkins : Checkins = {
        return Checkins(session: self)
        }()
    
    public lazy var tips : Tips = {
        return Tips(session: self)
        }()
    
    public lazy var lists : Lists = {
        return Lists(session: self)
        }()
    
    public lazy var updates : Updates = {
        return Updates(session: self)
        }()
    
    public lazy var photos : Photos = {
        return Photos(session: self)
        }()
    
    public lazy var settings : Settings = {
        return Settings(session: self)
        }()
    
    public lazy var specials : Specials = {
        return Specials(session: self)
        }()
    
    public lazy var events : Events = {
        return Events(session: self)
        }()
    
    public lazy var pages : Pages = {
        return Pages(session: self)
        }()
    
    public lazy var pageUpdates : PageUpdates = {
        return PageUpdates(session: self)
        }()
    
    public lazy var multi : Multi = {
        return Multi(session: self)
        }()
    
    public init(configuration: Configuration, completionQueue: NSOperationQueue) {
        self.configuration = configuration
        let URLConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.URLSession = NSURLSession(configuration: URLConfiguration, delegate: nil, delegateQueue: completionQueue)
        dataCache = DataCache(name: configuration.userTag)
        if configuration.debugEnabled {
            self.logger = ConsoleLogger()
        }
    }
    
    public convenience init(configuration: Configuration) {
        self.init(configuration:configuration, completionQueue: NSOperationQueue.mainQueue())
    }
    
    public class func setupSharedSessionWithConfiguration(configuration: Configuration) {
        if _sharedSession == nil {
            _sharedSession = Session(configuration: configuration)
        } else {
            fatalError("You shouldn't call call setupSharedSessionWithConfiguration twice!")
        }
    }
    
    public class func sharedSession() -> Session {
        if _sharedSession == nil {
            fatalError("You must call setupSharedInstanceWithConfiguration before!")
        }
        return _sharedSession!
    }
    
    /** Whether session is authorized or not. */
    public func isAuthorized() -> Bool {
        let keychain = Keychain(configuration: self.configuration)
        let (accessToken, _) = keychain.accessToken()
        return accessToken != nil
    }
    
    /** 
        Removes access token from keychain.
        This method doesn't post `QuadratSessionDidBecomeUnauthorizedNotification`.
    */
    public func deauthorize() {
        let keychain = Keychain(configuration: self.configuration)
        keychain.deleteAccessToken()
        dataCache.clearCache()
    }
    
    /** Returns cached image data. */
    public func cachedImageDataForURL(URL: NSURL) -> NSData? {
        return dataCache.dataForKey("\(URL.hash)")
    }
    
    /** Downloads image at URL and puts in cache. */
    public func downloadImageAtURL(URL: NSURL, completionHandler: DownloadImageClosure) {
        let request = NSURLRequest(URL: URL)
        let task = self.URLSession.downloadTaskWithRequest(request) {
            (fileURL, response, error) -> Void in
            if fileURL != nil {
                let data = NSData(contentsOfURL: fileURL)
                self.dataCache.addFileAtURL(fileURL, withKey: "\(URL.hash)")
                completionHandler(imageData: data, error: error)
            } else {
                completionHandler(imageData: nil, error: error)
            }
        }
        task.resume()
    }
    
    func processResponse(response: Response) {
        if response.HTTPSTatusCode == 401 && self.isAuthorized() {
            self.deathorizeAndNotify()
        }
       self.logger?.session(self, didReceiveResponse: response)
    }
    
    func processError(error: NSError) {
        self.logger?.session(self, didGetError: error)
    }

    private func deathorizeAndNotify() {
        self.deauthorize()
        dispatch_async(dispatch_get_main_queue()) {
            let name = QuadratSessionDidBecomeUnauthorizedNotification
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: self)
        }
    }
    
}



