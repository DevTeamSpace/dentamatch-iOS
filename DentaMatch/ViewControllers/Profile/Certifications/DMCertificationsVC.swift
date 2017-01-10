//
//  DMCertificationsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMCertificationsVC: DMBaseVC {

    enum Certifications:Int {
        case profileHeader
        case certifications
    }
    
    @IBOutlet weak var certificationsTableView: UITableView!
    
    let profileProgress:CGFloat = 0.90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setup() {
        self.certificationsTableView.separatorColor = UIColor.clear
        self.certificationsTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.certificationsTableView.register(UINib(nibName: "CertificationsCell", bundle: nil), forCellReuseIdentifier: "CertificationsCell")        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToExecutiveSummaryVC, sender: self)
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
