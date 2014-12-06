//
//  AuthorizationViewController.swift
//  Quadrat
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit

enum AuthorizationViewControllerRequestStatus  {
    case None               // View controller has been initialized.
    case Loading            // Web view loading page.
    case Loaded             // Page has been loaded successfully.
    case Failed(NSError)    // Web view failed to load page with error.
}

public class AuthorizationViewController : UIViewController, UIWebViewDelegate {
    private let authorizationURL: NSURL
    private let redirectURL : NSURL
    
    /**
        Whether view controller should controll network activity indicator or not.
        Should be set before presenting view controller.
    */
    var shouldControllNetworkActivityIndicator = false
    
    private var networkActivityIndicator : NetworkActivityIndicatorController?
    private var activityIdentifier : Int?
    
    weak var delegate : AuthorizationDelegate?
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var statusLabel: UILabel!

    private var status : AuthorizationViewControllerRequestStatus = .None {
        didSet {
            self.updateUI()
        }
    }
    
    // MARK: -
    
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
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelButtonTapped"))
        self.navigationItem.leftBarButtonItem = cancelButton
        if shouldControllNetworkActivityIndicator {
            networkActivityIndicator = NetworkActivityIndicatorController()
        }
        self.loadAuthorizationPage()
    }
    
    // MARK: - Actions
    
    @objc func loadAuthorizationPage() {
        self.status = .Loading
        let request = NSURLRequest(URL: self.authorizationURL)
        self.webView.loadRequest(request)
    }
    
    @objc func cancelButtonTapped() {
        self.delegate?.userDidCancel()
    }
    
    // MARK: - Web view delegate methods
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let URLString = request.URL.absoluteString {
            if URLString.hasPrefix(self.redirectURL.absoluteString!) {
                // If we've reached redirect URL we should let know delegate.
                self.delegate?.didReachRedirectURL(request.URL)
                return false
            }
        }
        return true
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.status = .Failed(error)
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        self.status = .Loaded
    }
    
    // MARK: -
    
    /** Updates UI to current status. */
    func updateUI() {
        switch (self.status) {
            
        case .Loading:
            // Show activity indicator in rightBarButtonItem, hide web view and status label.
            networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            activityIdentifier = networkActivityIndicator?.beginNetworkActivity()
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            self.webView.alpha = 0.0
            self.statusLabel.hidden = true
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            let loadingButton = UIBarButtonItem(customView: activityIndicator)
            self.navigationItem.rightBarButtonItem = loadingButton
            
        case .Loaded:
            // Show web view, hide rightBarButtonItem and status label.
            networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            self.navigationItem.rightBarButtonItem = nil
            self.statusLabel.hidden = true
            if self.webView.alpha == 0.0 {
                UIView.animateWithDuration(0.2)
                    {   () -> Void in
                        self.webView.alpha = 1.0
                    }
            }
            
        case .Failed(let error):
            // Show refresh button and status label. Hide web view.
            networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: Selector("loadAuthorizationPage"))
            self.statusLabel.text = error.localizedDescription
            self.navigationItem.rightBarButtonItem = refreshButton
            self.webView.alpha = 0.0
            self.statusLabel.hidden = false
            
            
        case .None:
            // Hide everynthing.
            networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            self.navigationItem.rightBarButtonItem = nil
            self.webView.alpha = 0.0
            self.statusLabel.hidden = true
        }
    }
    
}
