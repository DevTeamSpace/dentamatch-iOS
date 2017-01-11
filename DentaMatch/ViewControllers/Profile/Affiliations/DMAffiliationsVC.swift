//
//  DMAffiliationsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMAffiliationsVC: DMBaseVC {

    enum Affiliations:Int {
        case profileHeader
        case affiliation
        case affiliationOther
    }
    
    @IBOutlet weak var affiliationsTableView: UITableView!
    
    let profileProgress:CGFloat = 0.80
    var isOtherSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    func setup() {
        self.affiliationsTableView.separatorColor = UIColor.clear
        self.affiliationsTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.affiliationsTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.affiliationsTableView.register(UINib(nibName: "AffiliationsCell", bundle: nil), forCellReuseIdentifier: "AffiliationsCell")
        self.affiliationsTableView.register(UINib(nibName: "AffliliationsOthersCell", bundle: nil), forCellReuseIdentifier: "AffliliationsOthersCell")
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToCertificationsVC, sender: self)
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
