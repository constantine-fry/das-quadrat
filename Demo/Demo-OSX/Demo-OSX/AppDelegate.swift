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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let client = Client(clientID:       "5P1OVCFK0CCVCQ5GBBCWRFGUVNX5R4WGKHL2DGJGZ32FDFKT",
                            clientSecret:   "UPZJO0A0XL44IHCD1KQBMAYGCZ45Z03BORJZZJXELPWHPSAR",
                            redirectURL:    "testapp123://foursquare")
        let configuration = Configuration(client:client)
        self.quadratSession = Session(configuration: configuration)
        
        let authorized = self.quadratSession.isAuthorized()
        print("authorized: ", authorized)
        let URL = Bundle.main.url(forResource: "Apple_Swift_Logo", withExtension: "png")
        let task = self.quadratSession.users.update(URL!) {
            (response) -> Void in
            print(response)
        }
        task.start()
        
        let task2 = self.quadratSession.users.get()
        let task3 = self.quadratSession.users.friends("self", parameters: nil)

        let multiTask = self.quadratSession.multi.get([task2, task3]){
            (responses) -> Void in
            print(responses)
        }
        multiTask.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func loginButtonClicked(_ sender: AnyObject) {
        self.quadratSession.authorizeWithViewController(self.window) {
                authorized, error in
                //
            }   
    }

}

