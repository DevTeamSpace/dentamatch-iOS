//
//  DMTermsAndConditionsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMTermsAndConditionsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Terms and Conditions"
        self.navigationController?.navigationBar.barTintColor = UIColor.color(withHexCode: kNavBarColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //self.navigationItem.leftBarButtonItem = barButton()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    
    func barButton() -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        button.backgroundColor = UIColor.green
        button.setTitle("A", for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }
    
    
    @IBAction func acceptButtonPressed(_ sender: AnyObject) {
    }
}
