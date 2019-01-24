//
//  DMTermsAndConditionsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class FullScreenWebView: UIWebView {
    
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

class DMTermsAndConditionsVC: DMBaseVC {
    @IBOutlet var webView: FullScreenWebView!
    var isPrivacyPolicy = false
    var request: URLRequest!

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        hideLoader()
    }

    // MARK: - Private Methods

    func setup() {
        showLoader()
        title = isPrivacyPolicy ? "PRIVACY POLICY" : "TERMS & CONDITIONS"
        request = isPrivacyPolicy ?
            URLRequest(url: URL(string: Constants.API.privacyPolicyURL)!) :
            URLRequest(url: URL(string: Constants.API.termsAndConditionsURL)!)
        webView.delegate = self
        webView.loadRequest(request)
        navigationItem.leftBarButtonItem = backBarButton()
        navigationController?.navigationBar.barTintColor = Constants.Color.navBarColor
    }
}

extension DMTermsAndConditionsVC: UIWebViewDelegate {

    // MARK: - WebView Delegates

    func webView(_: UIWebView, didFailLoadWithError _: Error) {
        hideLoader()
    }

    func webViewDidFinishLoad(_: UIWebView) {
        hideLoader()
    }
}
