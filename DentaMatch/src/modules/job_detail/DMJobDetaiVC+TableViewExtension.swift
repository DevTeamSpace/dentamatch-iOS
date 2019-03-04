import Foundation
import SwiftyJSON

extension DMJobDetailVC: UITableViewDataSource, UITableViewDelegate, JobDescriptionCellDelegate, DentistDetailCellDelegate, OfficeDescriptionCellDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        // For map
        // return 6
        return 5
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Blank")
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            if job!.jobType == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TempJobDetailCell") as? TempJobDetailCell
                cell?.selectionStyle = .none
                cell?.delegate = self
                cell?.setCellData(job: job!, isTagExpanded: self.isTagExpanded, recruiterId: recruiterId)
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DentistDetailCell") as? DentistDetailCell
                cell?.selectionStyle = .none
                cell?.delegate = self
                cell?.setCellData(job: job!, recruiterId: recruiterId)
                return cell!
            }
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell") as? AboutCell
            cell?.selectionStyle = .none
            cell?.setCellData(job: job!)
            cell?.googleMapButton.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobDescriptionCell") as! JobDescriptionCell
            cell.lblDescription.text = job?.templateDesc
            let height = JobDescriptionCell.requiredHeight(jobDescription: (job?.templateDesc)!, isReadMore: isReadMore)
            if height > 91 {
                cell.constarintBtnReadMoreLessHeight.constant = 41 // Button Show
                if isReadMore == true {
                    cell.btnReadMore.setTitle(Constants.Strings.readLess, for: .normal)
                } else {
                    cell.btnReadMore.setTitle(Constants.Strings.readMore, for: .normal)
                }
            } else {
                cell.constarintBtnReadMoreLessHeight.constant = 0 // Button Hide
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
                cell.heightConstraintReadMoreButton.constant = 41 // Button Show
                if isReadMoreOffice == true {
                    cell.readMoreButton.setTitle(Constants.Strings.readLess, for: .normal)
                } else {
                    cell.readMoreButton.setTitle(Constants.Strings.readMore, for: .normal)
                }
            } else {
                cell.heightConstraintReadMoreButton.constant = 0 // Button Hide
                cell.readMoreButton.setTitle("", for: .normal)
            }
            cell.needsUpdateConstraints()
            cell.delegate = self
            cell.selectionStyle = .none
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkingHoursTableCell") as! WorkingHoursTableCell
            cell.workingHoursLabel.attributedText = WorkingHoursTableCell.setAllDayText(job: job!)
            return cell

        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell") as! MapCell
            cell.selectionStyle = .none
            cell.setPinOnMap(job: job!)
            return cell
        default:
            break
        }
        return cell
    }

    func tableView(_: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return TableViewCellHeight.jobTitle.rawValue
        case 1:
            return UITableView.automaticDimension//TableViewCellHeight.about.rawValue
        case 2:
            let height = JobDescriptionCell.requiredHeight(jobDescription: (job?.templateDesc)!, isReadMore: isReadMore)
            return height
        case 3:
            let height = OfficeDescriptionCell.requiredHeight(jobDescription: (job?.officeDesc)!, isReadMore: isReadMoreOffice)
            return height
        case 4:
            // Working hours
            return WorkingHoursTableCell.requiredHeight(job: job!)
        case 5:
            return TableViewCellHeight.map.rawValue
        default:
            break
        }
        return 0
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if job!.jobType == 3 {
                return  UITableView.automaticDimension
            }
            return (job?.isApplied ?? 0 ) > 0 ? TableViewCellHeight.jobTitle.rawValue + 20: TableViewCellHeight.jobTitle.rawValue
        case 1:
            return UITableView.automaticDimension
        case 2:
            let height = JobDescriptionCell.requiredHeight(jobDescription: (job?.templateDesc)!, isReadMore: isReadMore)
            return height
        case 3:
            let height = OfficeDescriptionCell.requiredHeight(jobDescription: (job?.officeDesc)!, isReadMore: isReadMoreOffice)
            return height
        // return TableViewCellHeight.jobDescAndOfficeDesc.rawValue
        case 4:
            // Working hours
            return UITableView.automaticDimension
        // return WorkingHoursTableCell.requiredHeight(job: job!)
        case 5:
            return TableViewCellHeight.map.rawValue
        default:
            break
        }
        return 0
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return headerHeight
        }
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: JobDetailHeaderView! = Bundle.main.loadNibNamed("JobDetailHeaderView", owner: nil, options: nil)?[0] as? JobDetailHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerHeight)
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
            headerView.setHeaderData(iconText: Constants.DesignFont.map, headerText: Constants.Strings.workingHours)
            headerView.btnIcon.setImage(UIImage(named: "workingHoursIcon"), for: .normal)
            return headerView

        case 5:
            headerView.setHeaderData(iconText: Constants.DesignFont.map, headerText: Constants.Strings.map)
            return headerView
        default:
            break
        }
        return headerView
    }

    // MARK: - JobDescriptionCellDelegate Method

    func readMoreOrReadLess() {
        isReadMore = isReadMore ? false : true
        tblJobDetail.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
    }

    func readMoreOrReadOfficeDescription() {
        isReadMoreOffice = isReadMoreOffice ? false : true
        tblJobDetail.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .automatic)
    }

    @objc func openMaps() {
        if UIApplication.shared.canOpenURL(URL(string: kOpenGoogleMapUrl)!) {
            let url = URL(string: "\(kOpenGoogleMapUrl)?q=\(job!.latitude),\(job!.longitude)&zoom=14")!

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }

        } else {
            let url = URL(string: "\(kGoogleSearchMap)\(job!.latitude),\(job!.longitude)")!

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }

    //*****************************************//
    //MARK: - DentistDetailCellDelegate Method
    //*****************************************//
    func saveOrUnsaveJob() {
        viewOutput?.saveUnsave(job: job)
    }
    
    func seeMoreTags(isExpanded: Bool) {
        self.isTagExpanded = isExpanded
        let indexpath = IndexPath(row: 0, section: 0)
        tblJobDetail.reloadRows(at: [indexpath], with: .fade)
        
    }
    
    func openChat(chatObject: ChatObject) {
        viewOutput?.openChat(chatObject: chatObject)
    }
}
