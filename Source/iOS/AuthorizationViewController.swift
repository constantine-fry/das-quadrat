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

/** 
    The class where AuthorizationViewController is pushed. It does nothing.
    You may use this class to apply you application style via UIAppearence.
*/
public class AuthorizationNavigationController: UINavigationController {
    
}

public class AuthorizationViewController : UIViewController, UIWebViewDelegate {
    private let authorizationURL    : NSURL
    private let redirectURL         : NSURL
    
    /**
        Whether view controller should controll network activity indicator or not.
        Should be set before presenting view controller.
    */
    internal var shouldControllNetworkActivityIndicator = false
    
    private var networkActivityIndicator    : NetworkActivityIndicatorController?
    private var activityIdentifier          : Int?
    
    weak internal var authorizationDelegate : AuthorizationDelegate?
    
    @IBOutlet public weak var webView       : UIWebView!
    
    @IBOutlet private weak var statusLabel  : UILabel!
    @IBOutlet private weak var indicator    : UIActivityIndicatorView!
    
    private var status : AuthorizationViewControllerRequestStatus = .None {
        didSet {
            self.updateUI()
        }
    }
    
    // MARK: -
    
    init(authorizationURL: NSURL, redirectURL: NSURL, delegate: AuthorizationDelegate) {
        self.authorizationURL = authorizationURL
        self.redirectURL = redirectURL
        self.authorizationDelegate = delegate
        let bundle = NSBundle(forClass: AuthorizationViewController.self)
        super.init(nibName: "AuthorizationViewController", bundle: bundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.showsVerticalScrollIndicator = false
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel,
            target: self, action: Selector("cancelButtonTapped"))
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
        self.authorizationDelegate?.userDidCancel()
    }
    
    // MARK: - Web view delegate methods
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest
        request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            if let URLString = request.URL?.absoluteString {
                if URLString.hasPrefix(self.redirectURL.absoluteString) {
                    // If we've reached redirect URL we should let know delegate.
                    self.authorizationDelegate?.didReachRedirectURL(request.URL!)
                    return false
                }
            }
            return true
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        if let error = error {
            if error.domain == "WebKitErrorDomain" && error.code == 102 {
                // URL loading was interrupted. It happens when one taps "download Foursquare to sign up!".
                return
            }
            self.status = .Failed(error)
        }
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        self.status = .Loaded
    }
    
    // MARK: -
    
    /** Updates UI to current status. */
    func updateUI() {
        switch (self.status) {
            
        case .Loading:
            // Show activity indicator, hide web view and status label.
            networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            activityIdentifier = networkActivityIndicator?.beginNetworkActivity()
            indicator.startAnimating()
            indicator.alpha = 1.0
            self.webView.alpha = 0.0
            self.statusLabel.hidden = true
            
        case .Loaded:
            // Show web view, hide activity indicator and status label.
            networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            
            self.statusLabel.hidden = true
            if self.webView.alpha == 0.0 {
                UIView.animateWithDuration(0.2, animations: {
                    self.indicator.alpha = 0.0
                    self.webView.alpha = 1.0
                    }, completion: { (finished) -> Void in
                        self.indicator.alpha = 1.0
                        self.indicator.stopAnimating()
                })
            }
            
        case .Failed(let error):
            // Show refresh button and status label. Hide web view.
            networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            
            self.statusLabel.text = error.localizedDescription
            self.indicator.stopAnimating()
            self.webView.alpha = 0.0
            self.statusLabel.hidden = false
            
            
        case .None:
            // Hide everynthing.
            networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            
            self.indicator.stopAnimating()
            self.webView.alpha = 0.0
            self.statusLabel.hidden = true
        }
    }
    
}
