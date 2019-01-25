//
//  DMCalendarSetAvailabillityVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 26/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMCalendarSetAvailabillityVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchTypeCell") as? JobSearchTypeCell
            cell?.delegate = self
            cell?.selectionStyle = .none
            cell?.setUpForButtons(isPartTime: (availablitytModel?.isParttime)!, isFullTime: (availablitytModel?.isFulltime)!)
            return cell!
        case 1:
            return getDynamicCellFor(tableView: tableView, indexPath: indexPath)

        default:
            break
        }
        return UITableViewCell()
    }

    func getDynamicCellFor(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if isPartTimeDayShow == true && isTemporyAvail == true {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchPartTimeCell") as? JobSearchPartTimeCell
                cell?.delegate = self
                cell?.setUp()
                cell?.daySelectFor(avail: availablitytModel!)
                cell?.selectionStyle = .none
                return cell!

            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCell") as? TemporyJobCell
                cell?.delegate = self
                cell?.setUpForButton(isTempTime: isTemporyAvail)
                cell?.selectionStyle = .none
                return cell!

            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCalenderCell") as? TemporyJobCalenderCell
                cell?.selectionStyle = .none
                cell?.selectPreSelctDate(dateArray: (availablitytModel?.tempJobDates)!)
                cell?.delegate = self
                return cell!

            default:
                break
            }
        } else if isPartTimeDayShow == false && isTemporyAvail == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCell") as? TemporyJobCell
            cell?.setUpForButton(isTempTime: isTemporyAvail)
            cell?.delegate = self

            cell?.selectionStyle = .none
            return cell!

        } else {
            if isPartTimeDayShow == true {
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchPartTimeCell") as? JobSearchPartTimeCell
                    cell?.delegate = self
                    cell?.setUp()
                    cell?.daySelectFor(avail: availablitytModel!)

                    cell?.selectionStyle = .none
                    return cell!

                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCell") as? TemporyJobCell
                    cell?.setUpForButton(isTempTime: isTemporyAvail)
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
                    cell?.setUpForButton(isTempTime: isTemporyAvail)
                    cell?.delegate = self

                    return cell!

                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TemporyJobCalenderCell") as? TemporyJobCalenderCell
                    cell?.selectionStyle = .none
                    cell?.selectPreSelctDate(dateArray: (availablitytModel?.tempJobDates)!)
                    cell?.delegate = self

                    return cell!

                default:
                    break
                }
            }
        }

        return UITableViewCell()
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 189
        } else {
            let height = getHeightForRow(indePath: indexPath)
            // debugPrint("height \(height)")
            return height
        }
    }

    func getHeightForRow(indePath: IndexPath) -> CGFloat {
        let tempJobCellHeight: CGFloat = 62
        let tempPartTimeJobHeight: CGFloat = 77
        let tempJobCalender: CGFloat = 310

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
        } else {
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

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
    }
}

extension DMCalendarSetAvailabillityVC: JobSearchTypeCellDelegate, TemporyJobCellDelegate, JobSearchPartTimeCellDelegate, TemporyJobCalenderCellDelegate {

    // MARK: JobSearchTypeCellDelegate Method

    func selectJobSearchType(selected: Bool, type: String) {
        if type == JobSearchType.PartTime.rawValue {
//            partTimeJobDays.removeAll()
            availablitytModel?.isParttime = selected
            if selected == true {
                if isPartTimeDayShow == false {
                    isPartTimeDayShow = !isPartTimeDayShow

                    calenderTableView.beginUpdates()
                    calenderTableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                    calenderTableView.endUpdates()
                    calenderTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableView.ScrollPosition.none, animated: false)
                }
                isJobTypePartTime = "1"
            } else {
                isPartTimeDayShow = !isPartTimeDayShow
                calenderTableView.beginUpdates()
                calenderTableView.deleteRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                calenderTableView.endUpdates()
                calenderTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableView.ScrollPosition.none, animated: false)
                isJobTypePartTime = "0"
            }
        } else {
            availablitytModel?.isFulltime = selected
            if selected == true {
                isJobTypeFullTime = "1"
            } else {
                isJobTypeFullTime = "0"
            }
        }
    }

    func selectTempJobType(selected: Bool) {
        isTemporyAvail = !isTemporyAvail

//        tempJobDays.removeAll()
        if selected == true {
            if isPartTimeDayShow == true {
                let path = IndexPath(row: 2, section: 1)
                tableUpdateFor(indexPath: path, action: 0)
            } else {
                let path = IndexPath(row: 1, section: 1)
                tableUpdateFor(indexPath: path, action: 0)
            }
        } else {
            if isPartTimeDayShow == true {
                let path = IndexPath(row: 2, section: 1)
                tableUpdateFor(indexPath: path, action: 1)

            } else {
                let path = IndexPath(row: 1, section: 1)
                tableUpdateFor(indexPath: path, action: 1)
            }
        }
    }

    // MARK: JobSearchPartTimeCellDelegate Method

    func selectDay(selected: Bool, day: String) {
        switch day {
        case "monday":
            availablitytModel?.isParttimeMonday = selected
        case "tuesday":
            availablitytModel?.isParttimeTuesday = selected
        case "wednesday":
            availablitytModel?.isParttimeWednesday = selected
        case "thursday":
            availablitytModel?.isParttimeThursday = selected
        case "friday":
            availablitytModel?.isParttimeFriday = selected
        case "saturday":
            availablitytModel?.isParttimeSaturday = selected
        case "sunday":
            availablitytModel?.isParttimeSunday = selected
        default:
            break
        }
    }

    func nextButtonDelegate(date _: Date) {
      //DO nothing
    }

    func previouseButtonDelegate(date _: Date) {
     //DO nothing
    }

    func tableUpdateFor(indexPath: IndexPath, action: Int) {
        if action == 0 {
            // add
            calenderTableView.beginUpdates()
            calenderTableView.insertRows(at: [indexPath], with: .none)
            calenderTableView.endUpdates()
            calenderTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableView.ScrollPosition.none, animated: false)
        } else {
            // delete
            calenderTableView.beginUpdates()
            calenderTableView.deleteRows(at: [indexPath], with: .none)
            calenderTableView.endUpdates()
            calenderTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableView.ScrollPosition.none, animated: false)
        }
    }

    func selectTempJobDate(selected: Date) {
        availablitytModel?.tempJobDates.append(Date.dateToString(date: selected))
        // debugPrint(self.availablitytModel?.tempJobDates ?? "dates are not avail")
    }

    func deSelectTempJobDate(deSelected: Date) {
        if (availablitytModel?.tempJobDates.contains(Date.dateToString(date: deSelected)))! {
            availablitytModel?.tempJobDates.remove(at: (availablitytModel?.tempJobDates.index(of: Date.dateToString(date: deSelected))!)!)
        }
        // debugPrint(self.availablitytModel?.tempJobDates ?? "dates are not avail")
    }
}
