//
//  AuthorizationWindowController.swift
//  Quadrat
//
//  Created by Constantine Fry on 09/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Cocoa
import WebKit

class AuthorizationWindowController: NSWindowController {
    var authorizationURL: NSURL!
    var redirectURL     : NSURL!
    var delegate        : AuthorizationDelegate?
    
    @IBOutlet weak var webView: WebView!

    override func windowDidLoad() {
        super.windowDidLoad()
        let request = NSURLRequest(URL: self.authorizationURL)
        self.webView.mainFrame.loadRequest(request)
    }
    
    @IBAction func doneButtonClicked(sender: AnyObject) {
        self.delegate?.userDidCancel()
    }
    
    override func webView(webView: WebView!, dragSourceActionMaskForPoint point: NSPoint) -> Int {
        return Int(WebDragSourceAction.None.rawValue)
    }
    
    override func webView(webView: WebView!, dragDestinationActionMaskForDraggingInfo draggingInfo: NSDraggingInfo!) -> Int {
        return Int(WebDragDestinationAction.None.rawValue)
    }
    
    override func webView(webView: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        if let URLString = request.URL.absoluteString {
            if URLString.hasPrefix(self.redirectURL.absoluteString!) {
                self.delegate?.didReachRedirectURL(request.URL)
                listener.ignore()
            }
        }
        listener.use()
    }
    
}
