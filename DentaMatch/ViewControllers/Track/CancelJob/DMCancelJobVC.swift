//
//  DMCancelJobVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 31/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMCancelJobVC: DMBaseVC {
    @IBOutlet weak var reasonTextView: UITextView!
 
    var jobId = 0
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    
    func setup() {
        self.title = "CANCEL JOB"
        self.changeNavBarAppearanceForDefault()
        self.navigationItem.leftBarButtonItem = self.backBarButton()
    }


    @IBAction func submitButtonPressed(_ sender: Any) {
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
