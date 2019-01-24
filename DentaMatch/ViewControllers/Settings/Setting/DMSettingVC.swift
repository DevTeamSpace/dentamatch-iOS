//
//  DMSettingVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 21/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMSettingVC: DMBaseVC {
    @IBOutlet var settingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    func setup() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        changeNavBarAppearanceForDefault()
        navigationItem.leftBarButtonItem = backBarButton()

        settingTableView.register(UINib(nibName: "SettingTableCell", bundle: nil), forCellReuseIdentifier: "SettingTableCell")
        settingTableView.separatorStyle = .none
        title = Constants.ScreenTitleNames.settings
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        changeNavBarAppearanceForDefault()
    }
}
