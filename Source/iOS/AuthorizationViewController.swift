//
//  AuthorizationViewController.swift
//  Quadrat
//
//  Created by Constantine Fry on 08/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation
import UIKit

private enum AuthorizationViewControllerRequestStatus {
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

public class AuthorizationViewController: UIViewController, UIWebViewDelegate {
    private let authorizationURL: NSURL
    private let redirectURL: NSURL
    
    /**
        Whether view controller should controll network activity indicator or not.
        Should be set before presenting view controller.
    */
    internal var shouldControlNetworkActivityIndicator = false
    
    private var networkActivityIndicator: NetworkActivityIndicatorController?
    private var activityIdentifier: Int?
    
    weak internal var authorizationDelegate: AuthorizationDelegate?
    
    @IBOutlet public weak var webView: UIWebView!
    
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    private var status: AuthorizationViewControllerRequestStatus = .None {
        didSet {
            self.updateUI()
        }
    }
    
    // MARK: -
    
    init(authorizationURL: NSURL, redirectURL: NSURL, delegate: AuthorizationDelegate) {
        self.authorizationURL = authorizationURL
        self.redirectURL = redirectURL
        self.authorizationDelegate = delegate
        let bundle = Bundle(for: AuthorizationViewController.self)
        super.init(nibName: "AuthorizationViewController", bundle: bundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.scrollView.showsVerticalScrollIndicator = false
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
            target: self, action: #selector(AuthorizationViewController.cancelButtonTapped))
        self.navigationItem.leftBarButtonItem = cancelButton
        if shouldControlNetworkActivityIndicator {
            networkActivityIndicator = NetworkActivityIndicatorController()
        }
        self.loadAuthorizationPage()
    }
    
    // MARK: - Actions
    
    @objc func loadAuthorizationPage() {
        self.status = .Loading
        let request = URLRequest(url: self.authorizationURL as URL)
        self.webView.loadRequest(request)
    }
    
    @objc func cancelButtonTapped() {
        self.authorizationDelegate?.userDidCancel()
    }
    
    // MARK: - Web view delegate methods
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith
        request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            if let URLString = request.url?.absoluteString {
                if URLString.hasPrefix(self.redirectURL.absoluteString!) {
                    // If we've reached redirect URL we should let know delegate.
                    self.authorizationDelegate?.didReachRedirectURL(request.url!)
                    return false
                }
            }
            return true
    }

    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        let error = error as NSError
        if error.domain == "WebKitErrorDomain" && error.code == 102 {
            // URL loading was interrupted. It happens when one taps "download Foursquare to sign up!".
            return
        }
        self.status = .Failed(error)
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.status = .Loaded
    }
    
    // MARK: -
    
    /** Updates UI to current status. */
    func updateUI() {
        switch self.status {
            
        case .Loading:
            // Show activity indicator, hide web view and status label.
            self.networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            self.activityIdentifier = networkActivityIndicator?.beginNetworkActivity()
            self.indicator.startAnimating()
            self.indicator.alpha = 1.0
            self.webView.alpha = 0.0
            self.statusLabel.isHidden = true
            
        case .Loaded:
            // Show web view, hide activity indicator and status label.
            self.networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            self.statusLabel.isHidden = true
            if self.webView.alpha == 0.0 {
                self.showWebViewWithAnimation()
            }
            
        case .Failed(let error):
            // Show refresh button and status label. Hide web view.
            self.networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            self.indicator.stopAnimating()
            self.webView.alpha = 0.0
            self.statusLabel.isHidden = false
            self.statusLabel.text = error.localizedDescription
            
        case .None:
            // Hide everynthing.
            self.networkActivityIndicator?.endNetworkActivity(activityIdentifier)
            self.indicator.stopAnimating()
            self.webView.alpha = 0.0
            self.statusLabel.isHidden = true
        }
    }
    
    private func showWebViewWithAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.indicator.alpha = 0.0
            self.webView.alpha = 1.0
            }, completion: { (finished) -> Void in
                self.indicator.alpha = 1.0
                self.indicator.stopAnimating()
        })
    }
    
}
