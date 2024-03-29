//
//  DMJobSearchVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMJobSearchVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            if isPartTimeDayShow == true {
                return 2
            }
            else {
                return 1
            }
        }
        else if section == 2 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Blank")
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobSeachTitleCell") as? JobSeachTitleCell
            cell?.selectionStyle = .none
            cell?.jobTitles = self.jobTitles
            cell!.updateJobTitle()
            return cell!
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchTypeCell") as? JobSearchTypeCell
                cell?.delegate = self
                cell?.selectionStyle = .none
                cell?.setCellData(isFullTime: isJobTypeFullTime, isPartTime: isJobTypePartTime)
                return cell!
            }
            else if  indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchPartTimeCell") as? JobSearchPartTimeCell
                cell?.delegate = self
                cell?.setUp()
                cell?.setCellData(parttimeDays: self.partTimeJobDays )
                cell?.selectionStyle = .none
                return cell!
            }
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentLocationCell") as! CurrentLocationCell
                cell.selectionStyle = .none
                cell.lblLocation.text = self.location.address
                return cell
            }
            else if  indexPath.row == 1 {
                return cell
            }  
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return TableViewCellHeight.jobType.rawValue
            }
            else if indexPath.row == 1 {
                return TableViewCellHeight.jobTypePartTime.rawValue
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return UITableViewAutomaticDimension
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return TableViewCellHeight.jobTitleAndLocation.rawValue
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return TableViewCellHeight.jobType.rawValue
            }
            else if indexPath.row == 1 {
                return TableViewCellHeight.jobTypePartTime.rawValue
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return TableViewCellHeight.jobTitleAndLocation.rawValue
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 0
        }
        else if section == 1 {
            return 22
        }
        else if section == 2 {
            return 20
        }
        return 0
    }
    
    func tableView (_ tableView:UITableView,  viewForHeaderInSection section:Int)->UIView?
    {
        var height : CGFloat!
        if section == 1 {
            height =  22
        }
        else if section == 2 {
            height =  20
        }
        let headerView:UIView! = UIView (frame:CGRect (x : 0,y : 0, width : self.tblViewJobSearch.frame.size.width,height : height))
        headerView.backgroundColor = self.tblViewJobSearch.backgroundColor
        
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let jobTitleVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobTitleVC.self)!
            jobTitleVC.delegate = self
            jobTitleVC.selectedJobs = self.jobTitles
            self.navigationController?.pushViewController(jobTitleVC, animated: true)
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                //will implement
            }
            else if indexPath.row == 1 {
                //will implement
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let registerMapsVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegisterMapsVC.self)!
                registerMapsVC.delegate = self
                registerMapsVC.fromJobSearch = true
                self.navigationController?.pushViewController(registerMapsVC, animated: true)
            }
            else if indexPath.row == 1 {
                //will implement
            }
        }
    }
}

