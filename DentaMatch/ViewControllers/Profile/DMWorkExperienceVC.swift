//
//  DMWorkExperienceVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 03/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMWorkExperienceVC: DMBaseVC,UITableViewDataSource,UITableViewDelegate {

    let NAVBAR_CHANGE_POINT:CGFloat = 64
    @IBOutlet weak var workExperienceTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUp() {
         self.navigationController!.navigationBar.lt_setBackgroundColor(UIColor.clear)
        self.workExperienceTable.register(UINib(nibName: "AnimatedPHTableCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHTableCell")
        self.workExperienceTable.separatorStyle = .none
        self.workExperienceTable.reloadData()

    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let color = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)//UIColor(red: CGFloat(155.0 / 255.0), green: CGFloat(255 / 255.0), blue: CGFloat(240 / 255.0), alpha: CGFloat(1))
        let offsetY: CGFloat = scrollView.contentOffset.y
        if offsetY > NAVBAR_CHANGE_POINT {
            let alpha: CGFloat = min(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64))
            self.navigationController!.navigationBar.lt_setBackgroundColor(color.withAlphaComponent(alpha))
        }
        else {
            self.navigationController!.navigationBar.lt_setBackgroundColor(color.withAlphaComponent(0))
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 45))
        let headerLabel = UILabel(frame: headerView.frame)
        headerLabel.frame.origin.x = 20
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.font = UIFont.fontMedium(fontSize: 14)
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        headerLabel.text = "Work Experiense"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
//        if section == 0
//        {
//            return 0
//        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell

        cell.cellTopSpace.constant = 10
        cell.cellBottomSpace.constant = 10.5
        cell.commonTextFiled.placeholder = "License Number"

        return cell
    }

    
    
}
