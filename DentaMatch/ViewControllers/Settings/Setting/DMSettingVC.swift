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
        self.title = Constants.ScreenTitleNames.settings
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.changeNavBarAppearanceForDefault()
    }
}
