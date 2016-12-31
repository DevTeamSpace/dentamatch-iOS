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
        let request = URLRequest(url: URL(string:"https://www.google.co.in")!)
        webView.loadRequest(request)
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.title = "TERMS & CONDITIONS"
        self.navigationController?.navigationBar.barTintColor = UIColor.color(withHexCode: kNavBarColor)
    }
    
    @IBAction func acceptButtonPressed(_ sender: AnyObject) {
        let jobTitleSectionVC = UIStoryboard.profileStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.profileNav)
        UIView.transition(with: self.view.window!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            kAppDelegate.window?.rootViewController = jobTitleSectionVC
        }) { (bool:Bool) in
            
        }
    }
}
