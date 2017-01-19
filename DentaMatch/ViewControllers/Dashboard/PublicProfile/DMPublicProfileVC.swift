//
//  DMPublicProfileVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMPublicProfileVC: DMBaseVC {

    @IBOutlet weak var publicProfileTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    func setup() {
        self.title = "EDIT PROFILE"
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.publicProfileTableView.register(UINib(nibName: "EditPublicProfileTableCell", bundle: nil), forCellReuseIdentifier: "EditPublicProfileTableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
