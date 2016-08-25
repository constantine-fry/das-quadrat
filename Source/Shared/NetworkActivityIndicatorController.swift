//
//  NetworkActivityIndicatorController.swift
//  Quadrat
//
//  Created by Constantine Fry on 06/12/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
#endif

/** Last issued identifier. */
private var currentIdentifier: Int = 0

/** Active identifiers. If it's empty network activity indicator should be hidden. */
private var activeIdentifiers: [Int:Int]! = [Int:Int]()

public let invalidNetworkActivityIdentifier = -1

/** Controlls network activity indicator on iOS. Does nothing on OSX. */
public class NetworkActivityIndicatorController {
    
    private let mainQueue = NSOperationQueue.mainQueue()

    /** Shows network activity indicator and return activity identifier. */
    func beginNetworkActivity() -> Int {
        #if os(iOS)
            let result = currentIdentifier + 1
            activeIdentifiers[result] = result
            self.mainQueue.addOperationWithBlock {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
            return result
        #else
            return invalidNetworkActivityIdentifier
        #endif
    }
    
    /** Hides network activity indicator when no one needed it anymore. Does nothing if you pass nil */
    func endNetworkActivity(identifier: Int?) {
        if identifier == nil {
            return
        }
        #if os(iOS)
            activeIdentifiers.removeValueForKey(identifier!)
            self.mainQueue.addOperationWithBlock {
                if activeIdentifiers.count == 0 {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            }
        #endif
    }
    
}
