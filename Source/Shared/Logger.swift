//
//  Logger.swift
//  Quadrat
//
//  Created by Constantine Fry on 28/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

/**
    Logger protocol. Main purpose to log error accured in Session.
    One can log all the errors in his own log file or track all errors with some analytic tool.
*/
public protocol Logger {
    
    /** All pesponses which session receive will be passed into this method. Can be called on any thread. */
    func session(session: Session, didReceiveResult result: Result)
    
    /** All errors will be passed in this method. Can be called on any thread. */
    func logError(error: NSError, withMessage message: String)
}

/** A simple logger which prints result in console. */
public class ConsoleLogger: Logger {
    
    public init() {}
    
    public func logError(error: NSError, withMessage message: String) {
        print("\(message): \(error)")
    }
    
    public func session(session: Session, didReceiveResult result: Result) {
        print("")
        print("Session did receive response:  \(result.HTTPSTatusCode), \(result.URL)")
        if let warning = result.response?["warning"] as? [String: AnyObject] {
            if let text = warning["text"] as? String {
                print("Warning: \(text)")
            }
        }
        if let error = result.error {
            print("Error: \(error)")
        }
        print("")
    }
}
