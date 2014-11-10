//
//  AppDelegate.swift
//  Demo-OSX
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Cocoa

import Quadrat

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var quadratSession : Session!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let client = Client(clientID:       "5P1OVCFK0CCVCQ5GBBCWRFGUVNX5R4WGKHL2DGJGZ32FDFKT",
                            clientSecret:   "UPZJO0A0XL44IHCD1KQBMAYGCZ45Z03BORJZZJXELPWHPSAR",
                            redirectURL:    "testapp123://foursquare")
        let configuration = Configuration(client:client)
        self.quadratSession = Session(configuration: configuration)

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func loginButtonClicked(sender: AnyObject) {
        self.quadratSession.authorizeWithViewController(self.window)
            {
                //
            }   
    }

}

