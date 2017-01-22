//
//  DMSettingVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 21/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMSettingVC: DMBaseVC {
    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.changeNavBarAppearanceForDefault()
        self.navigationItem.leftBarButtonItem = self.backBarButton()

        self.settingTableView.register(UINib(nibName: "SettingTableCell", bundle: nil), forCellReuseIdentifier: "SettingTableCell")
        self.settingTableView.separatorStyle = .none
        self.title = "SETTINGS"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
