//
//  DMJobSearchVC+TableViewCellDelegateExtension.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMJobSearchVC: DMJobTitleVCDelegate {
    func setSelectedJobType(jobTitles: [JobTitle]) {
        self.jobTitles.removeAll()
        self.jobTitles = jobTitles
        tblViewJobSearch.beginUpdates()
        tblViewJobSearch.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        tblViewJobSearch.endUpdates()
    }

    func setSelectedPreferredLocations(preferredLocations: [PreferredLocation]) {
        self.preferredLocations.removeAll()
        self.preferredLocations = preferredLocations
        tblViewJobSearch.beginUpdates()
        tblViewJobSearch.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .fade)
        tblViewJobSearch.endUpdates()
    }
}

extension DMJobSearchVC: LocationAddressDelegate {
    func locationAddress(location: Location) {
        self.location = location
        if location.address != nil {
            city = self.location.city
            country = self.location.country
            state = self.location.state
            tblViewJobSearch.beginUpdates()
            tblViewJobSearch.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .bottom)
            tblViewJobSearch.endUpdates()
            tblViewJobSearch.scrollToRow(at: IndexPath(row: 0, section: 2), at: UITableView.ScrollPosition.none, animated: false)
            // debugPrint(self.location.address!)
        } else {
            // debugPrint("Address is empty")
        }
    }
}

extension DMJobSearchVC: JobSearchTypeCellDelegate, JobSearchPartTimeCellDelegate {

    // MARK: JobSearchTypeCellDelegate Method

    func selectJobSearchType(selected: Bool, type: String) {
        if type == JobSearchType.PartTime.rawValue {
            if selected == true {
                isJobTypePartTime = "1"
                isPartTimeDayShow = true
            } else {
                isPartTimeDayShow = !isPartTimeDayShow
                tblViewJobSearch.beginUpdates()
                tblViewJobSearch.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .none)
                tblViewJobSearch.endUpdates()
                tblViewJobSearch.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableView.ScrollPosition.none, animated: false)
                isPartTimeDayShow = false
                isJobTypePartTime = "0"
                partTimeJobDays.removeAll()
            }
            if isPartTimeDayShow == true {
                tblViewJobSearch.beginUpdates()
                tblViewJobSearch.insertRows(at: [IndexPath(row: 1, section: 1)], with: .none)
                tblViewJobSearch.endUpdates()
                tblViewJobSearch.scrollToRow(at: IndexPath(row: 1, section: 1), at: UITableView.ScrollPosition.none, animated: false)
            }
        } else {
            if selected == true {
                isJobTypeFullTime = "1"
            } else {
                isJobTypeFullTime = "0"
            }
        }
    }

    // MARK: JobSearchPartTimeCellDelegate Method

    func selectDay(selected: Bool, day: String) {
        if selected == true {
            if partTimeJobDays.contains(day) {
                // will implement
            } else {
                partTimeJobDays.append(day)
            }
        } else {
            if partTimeJobDays.contains(day) {
                partTimeJobDays.remove(at: partTimeJobDays.index(of: day)!)
            }
        }
    }
}
