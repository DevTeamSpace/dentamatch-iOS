//
//  DMTermsAndConditionsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMTermsAndConditionsVC: DMBaseVC {

    @IBOutlet weak var webView: UIWebView!
    var isPrivacyPolicy = false
    var request:URLRequest!
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    
    func setup() {
        request = isPrivacyPolicy ?
            URLRequest(url: URL(string:Constants.API.privacyPolicyURL)!) :
            URLRequest(url: URL(string:Constants.API.termsAndConditionsURL)!)
        
        webView.loadRequest(request)
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.title = "TERMS & CONDITIONS"
        self.navigationController?.navigationBar.barTintColor = UIColor.color(withHexCode: kNavBarColor)
    }
    
    @IBAction func acceptButtonPressed(_ sender: AnyObject) {
    }
}
