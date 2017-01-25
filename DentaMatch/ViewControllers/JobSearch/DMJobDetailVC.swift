//
//  DMJobDetailVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMJobDetailVC: DMBaseVC {
    
    @IBOutlet weak var tblJobDetail: UITableView!
    @IBOutlet weak var btnApplyForJob: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK :- Private Method
    
    func setup() {
        self.tblJobDetail.rowHeight = UITableViewAutomaticDimension
        self.tblJobDetail.register(UINib(nibName: "DentistDetailCell", bundle: nil), forCellReuseIdentifier: "DentistDetailCell")
        self.tblJobDetail.register(UINib(nibName: "AboutCell", bundle: nil), forCellReuseIdentifier: "AboutCell")
        self.tblJobDetail.register(UINib(nibName: "JobDescriptionCell", bundle: nil), forCellReuseIdentifier: "JobDescriptionCell")
        self.tblJobDetail.register(UINib(nibName: "OfficeDescriptionCell", bundle: nil), forCellReuseIdentifier: "OfficeDescriptionCell")
        self.tblJobDetail.register(UINib(nibName: "MapCell", bundle: nil), forCellReuseIdentifier: "MapCell")
    }
    
    //MARK:- Apply For Job
    
    @IBAction func actionApplyForJob(_ sender: UIButton) {
    }
    
}

extension DMJobDetailVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Blank")
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DentistDetailCell") as? DentistDetailCell
            cell?.selectionStyle = .none
            return cell!
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell") as? AboutCell
                cell?.selectionStyle = .none
                return cell!
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JobDescriptionCell") as! JobDescriptionCell
                cell.selectionStyle = .none
                return cell
            }
        }
        else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OfficeDescriptionCell") as? OfficeDescriptionCell
                cell?.selectionStyle = .none
                return cell!
            }
        }
        else if indexPath.section == 4 {
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "MapCell") as! MapCell
                cell.selectionStyle = .none
                return cell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 115.0
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 216.0
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 175.0
            }
        }
        else if indexPath.section == 3 {
            if indexPath.row == 0 {
                return 175.0
            }
        }
        else if indexPath.section == 4 {
            if indexPath.row == 0 {
                return 199.0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 115.0
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 216.0
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 175.0
            }
        }
        else if indexPath.section == 3 {
            if indexPath.row == 0 {
                return 175.0
            }
        }
        else if indexPath.section == 4 {
            if indexPath.row == 0 {
                return 199.0
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 49.0
    }
    
    func tableView (_ tableView:UITableView,  viewForHeaderInSection section:Int)->UIView?
    {
        let headerView : UIView! = JobDetailHeaderView.init(frame : CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 49.0))
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
