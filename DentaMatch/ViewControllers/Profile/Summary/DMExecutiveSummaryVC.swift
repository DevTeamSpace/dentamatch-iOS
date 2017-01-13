//
//  DMExecutiveSummaryVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMExecutiveSummaryVC: DMBaseVC {

    enum ExecutiveSummary:Int {
        case profileHeader
        case aboutMe
    }
    
    
    @IBOutlet weak var executiveSummaryTableView: UITableView!
    
    let profileProgress:CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    func setup() {
        self.executiveSummaryTableView.separatorColor = UIColor.clear
        self.executiveSummaryTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.executiveSummaryTableView.register(UINib(nibName: "AboutMeCell", bundle: nil), forCellReuseIdentifier: "AboutMeCell")
    }
    
    @IBAction func completeProfileButtonClicked(_ sender: Any) {
    }

}
