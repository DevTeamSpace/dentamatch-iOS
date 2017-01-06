//
//  DMWorkExperienceStart.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 04/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMWorkExperienceStart: DMBaseVC,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DMYearExperiencePickerViewDelegate {
    @IBOutlet weak var workExperienceTable: UITableView!

    var experienceArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        experienceArray.addObjects(from: ["","",""])
        setUp()
        // Do any additional setup after loading the view.
    }

    func setUp() {
        self.workExperienceTable.register(UINib(nibName: "AnimatedPHTableCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHTableCell")
        self.workExperienceTable.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        workExperienceTable.separatorStyle = .none
        self.workExperienceTable.reloadData()
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.changeNavBarAppearanceForWithoutHeader()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //goToExperienceDetail
    @IBAction func nextButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "goToExperienceDetail", sender: self)

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
