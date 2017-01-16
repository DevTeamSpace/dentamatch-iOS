//
//  DMStudyVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMStudyVC: DMBaseVC {

    enum Study:Int {
        case profileHeader
        case school
    }
    
    @IBOutlet weak var studyTableView: UITableView!
    
    let profileProgress:CGFloat = 0.50
    var school = [[String:AnyObject]()]

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        prepareTempData()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.studyTableView.separatorColor = UIColor.clear
        self.studyTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.studyTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.studyTableView.register(UINib(nibName: "StudyCell", bundle: nil), forCellReuseIdentifier: "StudyCell")
        self.changeNavBarAppearanceForWithoutHeader()
        self.changeNavBarToTransparent()
    }
    
    func prepareTempData() {
        
        school.removeAll()
        
        var dict = [String:AnyObject]()
        dict["id"] = "1" as AnyObject?
        dict["name"] = "Dental School/Training" as AnyObject?
        dict["isOpen"] = false as AnyObject
        
        school.append(dict)
        
        dict["id"] = "2" as AnyObject?
        dict["name"] = "Hygeine School" as AnyObject?
        dict["isOpen"] = false as AnyObject
        
        school.append(dict)

        
        dict["id"] = "3" as AnyObject?
        dict["name"] = "Dental Assisting School" as AnyObject?
        dict["isOpen"] = false as AnyObject
        
        school.append(dict)

        dict["id"] = "4" as AnyObject?
        dict["name"] = "Dental Lab Tech School" as AnyObject?
        dict["isOpen"] = false as AnyObject
        
        school.append(dict)

        self.studyTableView.reloadData()
        
    }

    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        let skillsVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMSkillsVC.self)!
        
        let selectSkillsVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMSelectSkillsVC.self)!

        let sideMenu = SSASideMenu(contentViewController: skillsVC, rightMenuViewController: selectSkillsVC)
        sideMenu.panGestureEnabled = false
        sideMenu.delegate = skillsVC
        //sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: true, scaleBackground: false))
        //sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 0.7))
        //sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.black, opacity: 0.6, radius: 6.0))
        
        self.navigationController?.pushViewController(sideMenu, animated: true)
        
        //self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToSkillsVC, sender: self)

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
