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
    var autoCompleteTable:AutoCompleteTable!
    let autoCompleteBackView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))

    var schoolCategories = [SchoolCategory]()
    var selectedUniversities = [String:AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    
        self.getSchoolListAPI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.studyTableView.addGestureRecognizer(tap)
        
        self.studyTableView.separatorColor = UIColor.clear
        self.studyTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.studyTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.studyTableView.register(UINib(nibName: "StudyCell", bundle: nil), forCellReuseIdentifier: "StudyCell")
        self.changeNavBarAppearanceForWithoutHeader()
        self.changeNavBarToTransparent()
        
        autoCompleteTable = UIView.instanceFromNib(type: AutoCompleteTable.self)!
        autoCompleteTable.delegate = self
        autoCompleteBackView.backgroundColor = UIColor.clear
        autoCompleteBackView.isHidden = true
        autoCompleteTable.isHidden = true
        autoCompleteTable.layer.cornerRadius = 8.0
        autoCompleteTable.clipsToBounds = true
        self.view.addSubview(autoCompleteBackView)
        self.view.addSubview(autoCompleteTable)        
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func hideAutoCompleteView() {
        autoCompleteBackView.isHidden = true
        autoCompleteTable.isHidden = true
    }
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            studyTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+200, 0)
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        studyTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
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

extension DMStudyVC:AutoCompleteSelectedDelegate {

    func didSelect(schoolCategoryId: String, university: University) {
        hideAutoCompleteView()
        selectedUniversities["other_\(schoolCategoryId)"] = nil
        selectedUniversities[schoolCategoryId] = university
        print(selectedUniversities)
        self.studyTableView.reloadData()
    }
}
