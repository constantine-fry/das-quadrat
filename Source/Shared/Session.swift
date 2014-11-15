//
//  FSSession.swift
//  Quadrat
//
//  Created by Constantine Fry on 26/10/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation


public let UserSelf = "self"

public typealias Parameters = [String:String]

private var _sharedSession : Session?

public class Session {
    let configuration       : Configuration
    let URLSession          : NSURLSession
    
    public lazy var users : Users = {
        return Users(configuration: self.configuration, session: self)
        }()
    
    public lazy var venues : Venues = {
        return Venues(configuration: self.configuration, session: self)
        }()
    
    public lazy var venueGroups : VenueGroups = {
        return VenueGroups(configuration: self.configuration, session: self)
        }()
    
    public lazy var checkins : Checkins = {
        return Checkins(configuration: self.configuration, session: self)
        }()
    
    public lazy var tips : Tips = {
        return Tips(configuration: self.configuration, session: self)
        }()
    
    public lazy var lists : Lists = {
        return Lists(configuration: self.configuration, session: self)
        }()
    
    public lazy var updates : Updates = {
        return Updates(configuration: self.configuration, session: self)
        }()
    
    public lazy var photos : Photos = {
        return Photos(configuration: self.configuration, session: self)
        }()
    
    public lazy var settings : Settings = {
        return Settings(configuration: self.configuration, session: self)
        }()
    
    public lazy var specials : Specials = {
        return Specials(configuration: self.configuration, session: self)
        }()
    
    public lazy var events : Events = {
        return Events(configuration: self.configuration, session: self)
        }()
    
    public lazy var pages : Pages = {
        return Pages(configuration: self.configuration, session: self)
        }()
    
    public lazy var pageUpdates : PageUpdates = {
        return PageUpdates(configuration: self.configuration, session: self)
        }()
    
    public init(configuration: Configuration, completionQueue: NSOperationQueue) {
        self.configuration = configuration
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.URLSession = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: completionQueue)
        if self.configuration.accessToken == nil {
            self.configuration.accessToken = Keychain().accessToken()
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
    
    
}
