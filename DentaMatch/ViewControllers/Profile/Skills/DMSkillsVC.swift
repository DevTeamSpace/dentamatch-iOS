//
//  DMSkillsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMSkillsVC: DMBaseVC {

    enum Skills:Int {
        case profileHeader
        case skills
    }
    
    let profileProgress:CGFloat = 0.65
    var skills = [Skill]()
    
    @IBOutlet weak var skillsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.getSkillListAPI()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.skillsTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.skillsTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.skillsTableView.register(UINib(nibName: "SkillsTableCell", bundle: nil), forCellReuseIdentifier: "SkillsTableCell")
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToAffiliationsVC, sender: self)
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
