//
//  DMSelectSkillsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMSelectSkillsVC: UIViewController {

    @IBOutlet weak var subSkillTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    func setup() {
        self.subSkillTableView.register(UINib(nibName: "SubSkillCell", bundle: nil), forCellReuseIdentifier: "SubSkillCell")
        self.subSkillTableView.rowHeight = UITableViewAutomaticDimension
        self.subSkillTableView.estimatedRowHeight = 50.0
    }
    
}

extension DMSelectSkillsVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubSkillCell") as! SubSkillCell
        return cell
    }
}
