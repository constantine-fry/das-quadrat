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

        self.quadratSession = Session.sharedSession()
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

