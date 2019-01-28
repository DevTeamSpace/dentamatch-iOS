//
//  DMJobSearchVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMJobSearchVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 3
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if isPartTimeDayShow == true {
                return 2
            } else {
                return 1
            }
        } else if section == 2 {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Blank")
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobSeachTitleCell") as? JobSeachTitleCell
            cell?.selectionStyle = .none
            cell?.jobTitles = jobTitles
            cell!.updateJobTitle()
            return cell!
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchTypeCell") as? JobSearchTypeCell
                cell?.delegate = self
                cell?.selectionStyle = .none
                cell?.setCellData(isFullTime: isJobTypeFullTime, isPartTime: isJobTypePartTime)
                return cell!
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchPartTimeCell") as? JobSearchPartTimeCell
                cell?.delegate = self
                cell?.setUp()
                cell?.setCellData(parttimeDays: partTimeJobDays)
                cell?.selectionStyle = .none
                return cell!
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobSeachTitleCell") as? JobSeachTitleCell
            cell?.selectionStyle = .none
            cell?.lblJobTitle.text = "PREFERRED LOCATION"
            cell?.preferredLocations = preferredLocations
            cell?.forPreferredLocation = true
            cell!.updateJobTitle()
            return cell!
        default:
            break
        }
        return cell
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return TableViewCellHeight.jobType.rawValue
            } else if indexPath.row == 1 {
                return TableViewCellHeight.jobTypePartTime.rawValue
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return UITableView.automaticDimension
            }
        }
        return 0
    }

    func tableView(_: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return TableViewCellHeight.jobTitleAndLocation.rawValue
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return TableViewCellHeight.jobType.rawValue
            } else if indexPath.row == 1 {
                return TableViewCellHeight.jobTypePartTime.rawValue
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return TableViewCellHeight.jobTitleAndLocation.rawValue
            }
        }
        return 0
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 22
        } else if section == 2 {
            return 20
        }
        return 0
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var height: CGFloat!
        if section == 1 {
            height = 22
        } else if section == 2 {
            height = 20
        }
        let headerView: UIView! = UIView(frame: CGRect(x: 0, y: 0, width: tblViewJobSearch.frame.size.width, height: height))
        headerView.backgroundColor = tblViewJobSearch.backgroundColor

        return headerView
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let jobTitleVC = DMJobTitleInitializer.initialize(delegate: self) as? DMJobTitleVC else { return }
            jobTitleVC.selectedJobs = jobTitles
            navigationController?.pushViewController(jobTitleVC, animated: true)
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                // will implement
            } else if indexPath.row == 1 {
                // will implement
            }
        } else if indexPath.section == 2 {
            guard let jobTitleVC = DMJobTitleInitializer.initialize(delegate: self) as? DMJobTitleVC else { return }
            jobTitleVC.delegate = self
            jobTitleVC.forPreferredLocations = true
            jobTitleVC.selectedPreferredLocations = preferredLocations
            navigationController?.pushViewController(jobTitleVC, animated: true)

//                let registerMapsVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegisterMapsVC.self)!
//                registerMapsVC.delegate = self
//                registerMapsVC.fromJobSearch = true
//                self.navigationController?.pushViewController(registerMapsVC, animated: true)
        }
    }
}
