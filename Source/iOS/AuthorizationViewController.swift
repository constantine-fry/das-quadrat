//
//  AuthorizationViewController.swift
//  Quadrat
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit

public class AuthorizationViewController : UIViewController, UIWebViewDelegate {
    let authorizationURL: NSURL
    let redirectURL : NSURL
    
    var delegate : AuthorizationDelegate?
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var statusLabel: UILabel!
    
    init(authorizationURL: NSURL, redirectURL: NSURL, delegate: AuthorizationDelegate) {
        self.authorizationURL = authorizationURL
        self.redirectURL = redirectURL
        self.delegate = delegate
        
        let bundle = NSBundle(forClass: AuthorizationViewController.self)
        super.init(nibName: "AuthorizationViewController", bundle: bundle)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Foursquare"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelButtonTapped"))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let request = NSURLRequest(URL: self.authorizationURL)
        self.webView.loadRequest(request)
    }
    
    @objc func cancelButtonTapped() {
        self.delegate?.userDidCancel()
    }
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let URLString = request.URL.absoluteString {
            if URLString.hasPrefix(self.redirectURL.absoluteString!) {
                self.delegate?.didRichRedirectURL(request.URL)
                return false
            }
        }
        return true
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.webView.hidden = true
        self.statusLabel.hidden = false
        self.statusLabel.text = error.localizedDescription
    }
}
