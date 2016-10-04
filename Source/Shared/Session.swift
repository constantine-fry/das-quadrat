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
public typealias ResponseClosure = (_ result: Result) -> Void

/** A nandler for image downloading. */
public typealias DownloadImageClosure = (_ imageData: Data?, _ error: NSError?) -> Void

/** Typealias for parameters dictionary. */
public typealias Parameters = [String:String]

/**
    Posted when session have access token, but server returns response with 401 HTTP code.
    Guaranteed to be posted an main thread.
*/
public let QuadratSessionDidBecomeUnauthorizedNotification = "QuadratSessionDidBecomeUnauthorizedNotification"

private var _sharedSession: Session?

open class Session {
    
    /** The coniguration. */
    let configuration: Configuration
    
    /** The session which perform all network requests. */
    let URLSession: Foundation.URLSession
    
    /** The current authorizer. */
    var authorizer: Authorizer?
    
    /** Used as image cache for downloaded files. */
    let dataCache: DataCache
    
    /** The queue on which tasks have to call completion handlers. */
    let completionQueue: OperationQueue
   
    /** The keychain. */
    let keychain: Keychain
    
    /** Manages network activity indicator. */
    var networkActivityController: NetworkActivityIndicatorController?

    /**
        One can create custom logger to process all errors and responses in one place.
        Main purpose is to debug or to track all the errors accured in framework via some analytic tool.
    */
    open var logger: Logger?
    
    open lazy var users: Users = {
        return Users(session: self)
    }()
    
    open lazy var venues: Venues = {
        return Venues(session: self)
    }()
    
    open lazy var venueGroups: VenueGroups = {
        return VenueGroups(session: self)
    }()
    
    open lazy var checkins: Checkins = {
        return Checkins(session: self)
    }()
    
    open lazy var tips: Tips = {
        return Tips(session: self)
    }()
    
    open lazy var lists: Lists = {
        return Lists(session: self)
    }()
    
    open lazy var updates: Updates = {
        return Updates(session: self)
    }()
    
    open lazy var photos: Photos = {
        return Photos(session: self)
    }()
    
    open lazy var settings: Settings = {
        return Settings(session: self)
    }()
    
    open lazy var specials: Specials = {
        return Specials(session: self)
    }()
    
    open lazy var events: Events = {
        return Events(session: self)
    }()
    
    open lazy var pages: Pages = {
        return Pages(session: self)
    }()
    
    open lazy var pageUpdates: PageUpdates = {
        return PageUpdates(session: self)
    }()
    
    open lazy var multi: Multi = {
        return Multi(session: self)
    }()
    
    public init(configuration: Configuration, completionQueue: OperationQueue = OperationQueue.main) {
        if configuration.shouldControllNetworkActivityIndicator {
            self.networkActivityController = NetworkActivityIndicatorController()
        }
        self.configuration = configuration
        self.completionQueue = completionQueue
        let URLConfiguration = URLSessionConfiguration.default
        URLConfiguration.timeoutIntervalForRequest = configuration.timeoutInterval
        let delegateQueue = OperationQueue()
        delegateQueue.maxConcurrentOperationCount = 1
        self.URLSession = Foundation.URLSession(configuration: URLConfiguration,
                                                delegate: nil, delegateQueue: delegateQueue)
        self.dataCache = DataCache(name: configuration.userTag)
        if configuration.debugEnabled {
            self.logger = ConsoleLogger()
        }
        self.keychain = Keychain(configuration: self.configuration)
        self.keychain.logger = self.logger
    }
    
    open class func setupSharedSessionWithConfiguration(_ configuration: Configuration,
        completionQueue: OperationQueue = OperationQueue.main) {
            if _sharedSession == nil {
                _sharedSession = Session(configuration: configuration, completionQueue: completionQueue)
            } else {
                fatalError("You shouldn't call call setupSharedSessionWithConfiguration twice!")
            }
    }
    
    open class func sharedSession() -> Session {
        if _sharedSession == nil {
            fatalError("You must call setupSharedInstanceWithConfiguration before!")
        }
        return _sharedSession!
    }
    
    /** Whether session is authorized or not. */
    open func isAuthorized() -> Bool {
        do {
            let accessToken = try self.keychain.accessToken()
            return accessToken != nil
        } catch {
            return false
        }
    }
    
    open func accessToken() -> String? {
        do {
            return try self.keychain.accessToken()
        } catch {
            return nil
        }
    }
    
    /** 
        Removes access token from keychain.
        This method doesn't post `QuadratSessionDidBecomeUnauthorizedNotification`.
    */
    open func deauthorize() {
        do {
            try self.keychain.deleteAccessToken()
            self.dataCache.clearCache()
        } catch {
            
        }
    }
    
    /** Returns cached image data. */
    open func cachedImageDataForURL(_ url: Foundation.URL) -> Data? {
        return self.dataCache.dataForKey("\((url as NSURL).hash)")
    }
    
    /** Downloads image at URL and puts in cache. */
    open func downloadImageAtURL(_ url: Foundation.URL, completionHandler: @escaping DownloadImageClosure) {
        let request = URLRequest(url: url)
        let identifier = networkActivityController?.beginNetworkActivity()
        let task = self.URLSession.downloadTask(with: request, completionHandler: {
            (fileURL, response, error) -> Void in
            self.networkActivityController?.endNetworkActivity(identifier)
            var data: Data?
            if let fileURL = fileURL {
                data = try? Data(contentsOf: fileURL)
                self.dataCache.addFileAtURL(fileURL, withKey: "\((url as NSURL).hash)")
            }
            self.completionQueue.addOperation {
                completionHandler(data, error as NSError?)
            }
        }) 
        task.resume()
    }
    
    func processResult(_ result: Result) {
        if result.HTTPSTatusCode == 401 && self.isAuthorized() {
            self.deathorizeAndNotify()
        }
       self.logger?.session(self, didReceiveResult: result)
    }

    fileprivate func deathorizeAndNotify() {
        self.deauthorize()
        DispatchQueue.main.async {
            let name = QuadratSessionDidBecomeUnauthorizedNotification
            NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: self)
        }
    }

}
