//
//  AuthorizationWindowController.swift
//  Quadrat
//
//  Created by Constantine Fry on 09/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Cocoa
import WebKit

private enum AuthorizationWindowControllerStatus {
    case None               // View controller has been initialized.
    case Loading            // Web view loading page.
    case Loaded             // Page has been loaded successfully.
    case Failed(NSError)    // Web view failed to load page with error.
}

class AuthorizationWindowController: NSWindowController {
    var authorizationURL: NSURL!
    var redirectURL: NSURL!
    weak var delegate: AuthorizationDelegate?
    private var status: AuthorizationWindowControllerStatus = .None {
        didSet {
            self.updateUI()
        }
    }
    
    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var loadIndicator: NSProgressIndicator!
    
    // MARK: -
    
    deinit {
        self.webView.mainFrame.stopLoading()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.loadAuthorizationURL()
    }
    
    func loadAuthorizationURL() {
        self.status = .Loading
        let request = NSURLRequest(URL: self.authorizationURL)
        self.webView.mainFrame.loadRequest(request)
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonClicked(sender: AnyObject) {
        self.delegate?.userDidCancel()
    }
    
    @IBAction func refreshButtonClicked(sender: AnyObject) {
        self.loadAuthorizationURL()
    }
    
    
    // MARK: - Delegate methods
    
    func webView(webView: WebView!, dragSourceActionMaskForPoint point: NSPoint) -> Int {
        return Int(WebDragSourceAction.None.rawValue)
    }
    
    func webView(webView: WebView!,
        dragDestinationActionMaskForDraggingInfo draggingInfo: NSDraggingInfo!) -> Int {
            return Int(WebDragDestinationAction.None.rawValue)
    }
    
    func webView(webView: WebView!,
        decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!,
        request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
            if let URLString = request.URL?.absoluteString {
                if URLString.hasPrefix(self.redirectURL.absoluteString) {
                    self.delegate?.didReachRedirectURL(request.URL!)
                    listener.ignore()
                }
            }
            listener.use()
    }
    
    func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        self.status = .Loaded
    }
    
    func webView(sender: WebView!, didFailLoadWithError error: NSError!, forFrame frame: WebFrame!) {
        self.status = .Failed(error)
    }
    
    func webView(sender: WebView!,
        didFailProvisionalLoadWithError error: NSError!, forFrame frame: WebFrame!) {
            self.status = .Failed(error)
    }
    
    // MARK: -
    
    /** Updates UI to current status. */
    func updateUI() {
        switch self.status {
            
        case .Loading:
            self.loadIndicator.startAnimation(self)
            self.statusLabel.stringValue = ""
            self.refreshButton.hidden = true
            
        case .Loaded:
            self.loadIndicator.stopAnimation(self)
            self.statusLabel.stringValue = ""
            self.refreshButton.hidden = true
            
        case .Failed(let error):
            self.loadIndicator.stopAnimation(self)
            self.statusLabel.stringValue = error.localizedDescription
            self.refreshButton.hidden = false
            
        case .None:
            self.loadIndicator.stopAnimation(self)
            self.statusLabel.stringValue = ""
            self.refreshButton.hidden = true
        }
    }
}
