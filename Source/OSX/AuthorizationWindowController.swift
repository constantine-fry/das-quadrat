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
    case none               // View controller has been initialized.
    case loading            // Web view loading page.
    case loaded             // Page has been loaded successfully.
    case failed(NSError)    // Web view failed to load page with error.
}

class AuthorizationWindowController: NSWindowController {
    var authorizationURL: URL!
    var redirectURL: URL!
    weak var delegate: AuthorizationDelegate?
    fileprivate var status: AuthorizationWindowControllerStatus = .none {
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
        self.status = .loading
        let request = URLRequest(url: self.authorizationURL)
        self.webView.mainFrame.load(request)
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonClicked(_ sender: AnyObject) {
        self.delegate?.userDidCancel()
    }
    
    @IBAction func refreshButtonClicked(_ sender: AnyObject) {
        self.loadAuthorizationURL()
    }
    
    
    // MARK: - Delegate methods
    
    func webView(_ webView: WebView!, dragSourceActionMaskForPoint point: NSPoint) -> Int {
        return Int(WebDragSourceAction().rawValue)
    }
    
    func webView(_ webView: WebView!,
        dragDestinationActionMaskForDraggingInfo draggingInfo: NSDraggingInfo!) -> Int {
            return Int(WebDragDestinationAction().rawValue)
    }
    
    func webView(_ webView: WebView!,
        decidePolicyForNavigationAction actionInformation: [AnyHashable: Any]!,
        request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
            if let URLString = request.url?.absoluteString {
                if URLString.hasPrefix(self.redirectURL.absoluteString) {
                    self.delegate?.didReachRedirectURL(request.url!)
                    listener.ignore()
                }
            }
            listener.use()
    }
    
    func webView(_ sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        self.status = .loaded
    }
    
    func webView(_ sender: WebView!, didFailLoadWithError error: NSError!, forFrame frame: WebFrame!) {
        self.status = .failed(error)
    }
    
    func webView(_ sender: WebView!,
        didFailProvisionalLoadWithError error: NSError!, forFrame frame: WebFrame!) {
            self.status = .failed(error)
    }
    
    // MARK: -
    
    /** Updates UI to current status. */
    func updateUI() {
        switch self.status {
            
        case .loading:
            self.loadIndicator.startAnimation(self)
            self.statusLabel.stringValue = ""
            self.refreshButton.isHidden = true
            
        case .loaded:
            self.loadIndicator.stopAnimation(self)
            self.statusLabel.stringValue = ""
            self.refreshButton.isHidden = true
            
        case .failed(let error):
            self.loadIndicator.stopAnimation(self)
            self.statusLabel.stringValue = error.localizedDescription
            self.refreshButton.isHidden = false
            
        case .none:
            self.loadIndicator.stopAnimation(self)
            self.statusLabel.stringValue = ""
            self.refreshButton.isHidden = true
        }
    }
}
