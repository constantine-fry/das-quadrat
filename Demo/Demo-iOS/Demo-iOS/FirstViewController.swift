//
//  FirstViewController.swift
//  Demo-iOS
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import UIKit

import QuadratTouch

class FirstViewController: UITableViewController {
    var quadratSession : Session?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = Configuration(  clientID:       "5P1OVCFK0CCVCQ5GBBCWRFGUVNX5R4WGKHL2DGJGZ32FDFKT",
            clientSecret:   "UPZJO0A0XL44IHCD1KQBMAYGCZ45Z03BORJZZJXELPWHPSAR",
            callbackURL:    "testapp123://foursquare",
            version:         nil,
            accessToken:     "0Y05CMDZ1LBMAILF1ZZOXKQUXCEUZT1X0Z55IM0FKMVRXDI5")
        self.quadratSession = Session(client: configuration)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func authorizeButtonTapped() {
        self.quadratSession?.authorizeWithViewController(self, completionHandler: { () -> Void in
            //
        })
    }
}

