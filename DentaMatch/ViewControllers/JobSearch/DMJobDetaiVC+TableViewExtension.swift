//
//  DMJobDetaiVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

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
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DentistDetailCell") as? DentistDetailCell
            cell?.selectionStyle = .none
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell") as? AboutCell
            cell?.selectionStyle = .none
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobDescriptionCell") as! JobDescriptionCell
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfficeDescriptionCell") as? OfficeDescriptionCell
            cell?.selectionStyle = .none
            return cell!
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell") as! MapCell
            cell.selectionStyle = .none
            return cell
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return TableViewCellHeight.jobTitle.rawValue
        case 1:
            return TableViewCellHeight.about.rawValue
        case 2:
            return TableViewCellHeight.jobDescAndOfficeDesc.rawValue
        case 3:
            return TableViewCellHeight.jobDescAndOfficeDesc.rawValue
        case 4:
            return TableViewCellHeight.map.rawValue
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return TableViewCellHeight.jobTitle.rawValue
        case 1:
            return TableViewCellHeight.about.rawValue
        case 2:
            return TableViewCellHeight.jobDescAndOfficeDesc.rawValue
        case 3:
            return TableViewCellHeight.jobDescAndOfficeDesc.rawValue
        case 4:
            return TableViewCellHeight.map.rawValue
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return headerHeight
    }
    
    func tableView (_ tableView:UITableView,  viewForHeaderInSection section:Int)->UIView?
    {
        let headerView : UIView! = JobDetailHeaderView.init(frame : CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight))
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
