//
//  DMJobDetailVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMJobDetailVC: DMBaseVC {
    
    @IBOutlet weak var tblJobDetail: UITableView!
    @IBOutlet weak var btnApplyForJob: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK :- Private Method
    
    func setup() {
        self.tblJobDetail.rowHeight = UITableViewAutomaticDimension
        self.tblJobDetail.register(UINib(nibName: "DentistDetailCell", bundle: nil), forCellReuseIdentifier: "DentistDetailCell")
        self.tblJobDetail.register(UINib(nibName: "AboutCell", bundle: nil), forCellReuseIdentifier: "AboutCell")
        self.tblJobDetail.register(UINib(nibName: "JobDescriptionCell", bundle: nil), forCellReuseIdentifier: "JobDescriptionCell")
        self.tblJobDetail.register(UINib(nibName: "OfficeDescriptionCell", bundle: nil), forCellReuseIdentifier: "OfficeDescriptionCell")
        self.tblJobDetail.register(UINib(nibName: "MapCell", bundle: nil), forCellReuseIdentifier: "MapCell")
    }
    
    //MARK:- @IBAction Method
    
    @IBAction func actionApplyForJob(_ sender: UIButton) {
    }
    
}
