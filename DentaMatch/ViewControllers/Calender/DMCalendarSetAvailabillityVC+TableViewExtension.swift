//
//  DMCalendarSetAvailabillityVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 26/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation


extension DMCalendarSetAvailabillityVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch section {
        case 0:
            return 1
        case 1:
            return calculatePartAndTemporyRows()
        default: break
            
        }
        return 0
    }
    
    func calculatePartAndTemporyRows() -> Int {
        if isPartTimeDayShow == true && isTemporyAvail == true {
            return 3
        } else if isPartTimeDayShow == false && isTemporyAvail == false {
            return 1
        }else{
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchTypeCell") as? JobSearchTypeCell
            cell?.delegate = self
            cell?.selectionStyle = .none
            cell?.setUpForButtons(isPartTime: (self.availablitytModel?.isParttime)!, isFullTime: (self.availablitytModel?.isFulltime)!)
            return cell!
        case 1:
            return getDynamicCellFor(tableView:tableView, indexPath: indexPath)
            
        default:
            break
        }
        return UITableViewCell()
        
        
    }
    func getDynamicCellFor(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell{
        
        if isPartTimeDayShow == true && isTemporyAvail == true {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchPartTimeCell") as? JobSearchPartTimeCell
                cell?.delegate = self
                cell?.setUp()
                cell?.daySelectFor(avail: self.availablitytModel!)
                cell?.selectionStyle = .none
                return cell!
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCell") as? TemporyJobCell
                cell?.delegate = self
                cell?.setUpForButton(isTempTime: self.isTemporyAvail)
                cell?.selectionStyle = .none
                return cell!
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCalenderCell") as? TemporyJobCalenderCell
                cell?.selectionStyle = .none
                cell?.delegate = self
                return cell!
                
                
                
            default:
                break
            }
        } else if isPartTimeDayShow == false && isTemporyAvail == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCell") as? TemporyJobCell
            cell?.setUpForButton(isTempTime: self.isTemporyAvail)
            cell?.delegate = self
            
            cell?.selectionStyle = .none
            return cell!
            
        }else{
            if isPartTimeDayShow == true {
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchPartTimeCell") as? JobSearchPartTimeCell
                    cell?.delegate = self
                    cell?.setUp()
                    cell?.daySelectFor(avail: self.availablitytModel!)
                    
                    cell?.selectionStyle = .none
                    return cell!
                    
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCell") as? TemporyJobCell
                    cell?.setUpForButton(isTempTime: self.isTemporyAvail)
                    cell?.delegate = self
                    
                    cell?.selectionStyle = .none
                    return cell!
                default: break
                    
                }
                
            }
            if isTemporyAvail == true {
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCell") as? TemporyJobCell
                    cell?.selectionStyle = .none
                    cell?.setUpForButton(isTempTime: self.isTemporyAvail)
                    cell?.delegate = self
                    
                    return cell!
                    
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCalenderCell") as? TemporyJobCalenderCell
                    cell?.selectionStyle = .none
                    cell?.delegate = self
                    
                    return cell!
                    
                default:
                    break
                }
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 189
        }
        else {
            let height  = getHeightForRow(indePath: indexPath)
            debugPrint("height \(height)")
            return height
            
        }
    }
    
    func getHeightForRow(indePath:IndexPath)  -> CGFloat{
        
        let tempJobCellHeight:CGFloat = 62
        let tempPartTimeJobHeight:CGFloat = 77
        let tempJobCalender:CGFloat = 310
        
        if isPartTimeDayShow == true && isTemporyAvail == true {
            switch indePath.row {
            case 0:
                return tempJobCellHeight
            case 1:
                return tempPartTimeJobHeight
            case 2:
                return tempJobCalender
            default:
                break
            }
            return tempJobCellHeight + tempJobCalender + tempPartTimeJobHeight
        } else if isPartTimeDayShow == false && isTemporyAvail == false {
            switch indePath.row {
            case 0:
                return tempJobCellHeight
            default:
                break
            }
            
            return tempJobCellHeight
        }else{
            if isPartTimeDayShow == true {
                switch indePath.row {
                case 0:
                    return tempJobCellHeight
                case 1:
                    return tempPartTimeJobHeight
                case 2:
                    return tempJobCalender
                default:
                    break
                }
                
                return tempPartTimeJobHeight
            }
            if isTemporyAvail == true {
                switch indePath.row {
                case 0:
                    return tempJobCellHeight
                case 1:
                    return tempJobCalender
                default:
                    break
                }
                
                return tempJobCalender
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension DMCalendarSetAvailabillityVC : JobSearchTypeCellDelegate,TemporyJobCellDelegate, JobSearchPartTimeCellDelegate,TemporyJobCalenderCellDelegate {
    
    //MARK : JobSearchTypeCellDelegate Method
    
    func selectJobSearchType(selected: Bool, type: String) {
        if type ==  JobSearchType.PartTime.rawValue {
            partTimeJobDays.removeAll()
            
            if selected == true  {
                if isPartTimeDayShow == false {
                    isPartTimeDayShow = !isPartTimeDayShow
                    calenderTableView.beginUpdates()
                    calenderTableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .none )
                    calenderTableView.endUpdates()
                    calenderTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableViewScrollPosition.none, animated: false)
                }
                isJobTypePartTime = "1"
            }
            else {
                isPartTimeDayShow = !isPartTimeDayShow
                calenderTableView.beginUpdates()
                calenderTableView.deleteRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                calenderTableView.endUpdates()
                calenderTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableViewScrollPosition.none, animated: false)
                isJobTypePartTime = "0"
            }
        }
        else {
            if selected == true  {
                isJobTypeFullTime = "1"
            }
            else {
                isJobTypeFullTime = "0"
            }
        }
    }
    
    func selectTempJobType(selected: Bool) {
        isTemporyAvail = !isTemporyAvail
        
        tempJobDays.removeAll()
        if selected == true  {
            if isPartTimeDayShow == true {
                let path = IndexPath(row: 2, section: 1)
                self.tableUpdateFor(indexPath: path, action: 0)
            }else {
                let path = IndexPath(row: 1, section: 1)
                self.tableUpdateFor(indexPath: path, action: 0)
                
            }
        }else{
            if isPartTimeDayShow == true {
                let path = IndexPath(row: 2, section: 1)
                self.tableUpdateFor(indexPath: path, action: 1)
                
            }else {
                let path = IndexPath(row: 1, section: 1)
                self.tableUpdateFor(indexPath: path, action: 1)
            }
            
        }
    }
    
    //MARK : JobSearchPartTimeCellDelegate Method
    
    func selectDay(selected: Bool, day: String) {
        if selected == true {
            if partTimeJobDays.contains(day) {
                
            }
            else {
                partTimeJobDays.append(day)
            }
        }
        else {
            if partTimeJobDays.contains(day) {
                partTimeJobDays.remove(at: partTimeJobDays.index(of: day)!)
            }
        }
    }
    
    func nextButtonDelegate(date : Date) {
        let dateData = Date.getMonthAndYearForm(date: date)
        self.getMyAvailabilityFromServer(month: dateData.month, year: dateData.year) { (responseData, error) in
            self.calenderTableView.reloadData()
            
            debugPrint(responseData ?? "response not available")
        }
        
    }
    func previouseButtonDelegate(date : Date) {
        let dateData = Date.getMonthAndYearForm(date: date)
        self.getMyAvailabilityFromServer(month: dateData.month, year: dateData.year) { (responseData, error) in
            self.calenderTableView.reloadData()
            
            debugPrint(responseData ?? "response not available")
        }
        
    }
    
    
    func tableUpdateFor(indexPath:IndexPath ,action:Int) {
        if action == 0 {
            //add
            calenderTableView.beginUpdates()
            calenderTableView.insertRows(at: [indexPath], with: .none )
            calenderTableView.endUpdates()
            calenderTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableViewScrollPosition.none, animated: false)
        }else  {
            //delete
            calenderTableView.beginUpdates()
            calenderTableView.deleteRows(at: [indexPath], with: .none)
            calenderTableView.endUpdates()
            calenderTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableViewScrollPosition.none, animated: false)
        }
    }
    func selectTempJobDate(selected: Date) {
        tempJobDays.append(Date.dateToString(date: selected))
        print(tempJobDays)
        
    }
    
    func deSelectTempJobDate(deSelected: Date) {
        if tempJobDays.contains(Date.dateToString(date: deSelected)) {
            tempJobDays.remove(at: tempJobDays.index(of: Date.dateToString(date: deSelected))!)
        }
        print(tempJobDays)
        
    }
    
}
