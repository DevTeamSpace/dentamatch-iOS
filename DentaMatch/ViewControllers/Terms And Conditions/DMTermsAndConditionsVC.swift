//
//  DMTermsAndConditionsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMTermsAndConditionsVC: DMBaseVC {

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        setup()
        self.navigationItem.leftBarButtonItem = self.backBarButton()
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
        self.title = "Terms and Conditions"
        self.navigationController?.navigationBar.barTintColor = UIColor.color(withHexCode: kNavBarColor)
    }
    
    
    @IBAction func acceptButtonPressed(_ sender: AnyObject) {
    }
}
