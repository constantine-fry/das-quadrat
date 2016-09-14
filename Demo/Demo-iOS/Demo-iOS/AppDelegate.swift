//
//  AppDelegate.swift
//  Demo-iOS
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import UIKit

import QuadratTouch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            
            self.window?.tintColor = UIColor(red: 71.0/255.0, green: 57.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            
            let client = Client(clientID: "5P1OVCFK0CCVCQ5GBBCWRFGUVNX5R4WGKHL2DGJGZ32FDFKT",
                            clientSecret: "UPZJO0A0XL44IHCD1KQBMAYGCZ45Z03BORJZZJXELPWHPSAR",
                             redirectURL: "testapp123://foursquare")
            var configuration = Configuration(client:client)
            configuration.mode = nil
            configuration.shouldControllNetworkActivityIndicator = true
            Session.setupSharedSessionWithConfiguration(configuration)
            return true
    }
    
    func application(_ application: UIApplication, open url: URL,
        sourceApplication: String?, annotation: Any) -> Bool {
            return Session.sharedSession().handleURL(url: url)
    }
    
}

