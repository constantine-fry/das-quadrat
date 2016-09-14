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
private var _currentIdentifier: Int = 0

/** Active identifiers. If it's empty network activity indicator should be hidden. */
private var _activeIdentifiers: [Int:Int]! = [Int:Int]()

public let InvalidNetworkActivityIdentifier = -1

/** Controlls network activity indicator on iOS. Does nothing on OSX. */
open class NetworkActivityIndicatorController {
    
    fileprivate let mainQueue = OperationQueue.main

    /** Shows network activity indicator and return activity identifier. */
    func beginNetworkActivity() -> Int {
        #if os(iOS)
            let result = _currentIdentifier + 1
            _activeIdentifiers[result] = result
            self.mainQueue.addOperation {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            return result
        #else
            return InvalidNetworkActivityIdentifier
        #endif
    }
    
    /** Hides network activity indicator when no one needed it anymore. Does nothing if you pass nil */
    func endNetworkActivity(_ identifier: Int?) {
        if identifier == nil {
            return
        }
        #if os(iOS)
            _activeIdentifiers.removeValue(forKey: identifier!)
            self.mainQueue.addOperation {
                if _activeIdentifiers.count == 0 {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        #endif
    }
    
}
