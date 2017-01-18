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
        case other
    }
    
    let profileProgress:CGFloat = 0.65
    var skills = [Skill]()
    var otherSkill:Skill?
    
    @IBOutlet weak var skillsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.getSkillListAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    
    func setup() {
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.skillsTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.skillsTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.skillsTableView.register(UINib(nibName: "SkillsTableCell", bundle: nil), forCellReuseIdentifier: "SkillsTableCell")
        self.skillsTableView.register(UINib(nibName: "OtherSkillCell", bundle: nil), forCellReuseIdentifier: "OtherSkillCell")
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        self.updateSkillsAPI(params: prepareSkillUpdateData())
    }
    
    func openAffiliationScreen() {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToAffiliationsVC, sender: self)

    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

extension DMSkillsVC: SSASideMenuDelegate {
    
    func sideMenuWillShowMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
        //side menu 
    }
    
    
    func sideMenuWillHideMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
        if let selectedIndex = self.skillsTableView.indexPathForSelectedRow {
            self.skillsTableView.deselectRow(at: selectedIndex, animated: true)
        }
        self.skillsTableView.reloadData()
    }
}
