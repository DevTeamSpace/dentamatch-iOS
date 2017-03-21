//
//  DMJobDetaiVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMJobDetailVC : UITableViewDataSource, UITableViewDelegate, JobDescriptionCellDelegate, DentistDetailCellDelegate, OfficeDescriptionCellDelegate {
    
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
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DentistDetailCell") as? DentistDetailCell
            cell?.selectionStyle = .none
            cell?.delegate = self
            cell?.setCellData(job: job!)
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell") as? AboutCell
            cell?.selectionStyle = .none
            cell?.setCellData(job: job!)
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobDescriptionCell") as! JobDescriptionCell
            cell.lblDescription.text = job?.templateDesc
            let height = JobDescriptionCell.requiredHeight(jobDescription: (job?.templateDesc)!, isReadMore: isReadMore)
            if height > 91 {
                cell.constarintBtnReadMoreLessHeight.constant = 41//Button Show
                if isReadMore == true {
                    cell.btnReadMore.setTitle(Constants.Strings.readLess, for: .normal)
                }
                else {
                    cell.btnReadMore.setTitle(Constants.Strings.readMore, for: .normal)
                }
            }
            else {
                cell.constarintBtnReadMoreLessHeight.constant = 0//Button Hide
                cell.btnReadMore.setTitle("", for: .normal)
            }
            cell.needsUpdateConstraints()
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfficeDescriptionCell") as! OfficeDescriptionCell
            cell.officeDescriptionLabel.text = job?.officeDesc
            let height = OfficeDescriptionCell.requiredHeight(jobDescription: (job?.officeDesc)!, isReadMore: isReadMoreOffice)
            if height > 91 {
                cell.heightConstraintReadMoreButton.constant = 41//Button Show
                if isReadMoreOffice == true {
                    cell.readMoreButton.setTitle(Constants.Strings.readLess, for: .normal)
                }
                else {
                    cell.readMoreButton.setTitle(Constants.Strings.readMore, for: .normal)
                }
            }
            else {
                cell.heightConstraintReadMoreButton.constant = 0//Button Hide
                cell.readMoreButton.setTitle("", for: .normal)
            }
            cell.needsUpdateConstraints()
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell") as! MapCell
            cell.selectionStyle = .none
            cell.setPinOnMap(job: job!)
            return cell
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return TableViewCellHeight.jobTitle.rawValue
        case 1:
            return TableViewCellHeight.about.rawValue
        case 2:
            let height = JobDescriptionCell.requiredHeight(jobDescription: (job?.templateDesc)!, isReadMore: isReadMore)
            return height
        case 3:
            let height = OfficeDescriptionCell.requiredHeight(jobDescription: (job?.officeDesc)!, isReadMore: isReadMoreOffice)
            return height
//            return TableViewCellHeight.jobDescAndOfficeDesc.rawValue
        case 4:
            return TableViewCellHeight.map.rawValue
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return TableViewCellHeight.jobTitle.rawValue
        case 1:
            return UITableViewAutomaticDimension
        case 2:
            let height = JobDescriptionCell.requiredHeight(jobDescription: (job?.templateDesc)!, isReadMore: isReadMore)
            return height
        case 3:
            let height = OfficeDescriptionCell.requiredHeight(jobDescription: (job?.officeDesc)!, isReadMore: isReadMoreOffice)
            return height
            //return TableViewCellHeight.jobDescAndOfficeDesc.rawValue
        case 4:
            return TableViewCellHeight.map.rawValue
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 0
        }
        else {
            return headerHeight
        }
    }
    
    func tableView (_ tableView:UITableView,  viewForHeaderInSection section:Int)->UIView?
    {
        let headerView : JobDetailHeaderView! = Bundle.main.loadNibNamed("JobDetailHeaderView", owner: nil, options: nil)?[0] as? JobDetailHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight)
        headerView.layoutIfNeeded()
        
        switch section {
        case 0:
            return nil
        case 1:
            headerView.setHeaderData(iconText: Constants.DesignFont.about, headerText: Constants.Strings.about)
            return headerView
        case 2:
            headerView.setHeaderData(iconText: Constants.DesignFont.jobDescription, headerText: Constants.Strings.jobDesc)
            return headerView
        case 3:
            headerView.setHeaderData(iconText: Constants.DesignFont.officeDescription, headerText: Constants.Strings.officeDesc)
            return headerView
        case 4:
            headerView.setHeaderData(iconText: Constants.DesignFont.map, headerText: Constants.Strings.map)
            return headerView
        default:
            break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK:- JobDescriptionCellDelegate Method
    func readMoreOrReadLess() {
        isReadMore = isReadMore ? false : true
        self.tblJobDetail.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
    }
    
    func readMoreOrReadOfficeDescription() {
        isReadMoreOffice = isReadMoreOffice ? false : true
        self.tblJobDetail.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .automatic)

    }
    
    //MARK:- DentistDetailCellDelegate Method
    func saveOrUnsaveJob() {
        var status : Int!
        if job?.isSaved == 1 {
            status = 0
        }
        else {
            status = 1
        }
        self.saveUnsaveJob(saveStatus: status, jobId: (job?.jobId)!) { (response:JSON?, error:NSError?) in
            if let response = response {
                if response[Constants.ServerKey.status].boolValue {
                    //Save Unsave success
                    self.job?.isSaved = status
                    if let delegate = self.delegate {
                        delegate.jobUpdate!(job: self.job!)
                    }
                    DispatchQueue.main.async {
                        self.tblJobDetail.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                    }
                }
            }
        }
    }
}
