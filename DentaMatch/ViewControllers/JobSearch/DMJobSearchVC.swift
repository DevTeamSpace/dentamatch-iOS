//
//  DMJobSearchVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 06/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import CoreLocation

class DMJobSearchVC : DMBaseVC {
    
    @IBOutlet weak var tblViewJobSearch: UITableView!
    var isPartTimeDayShow : Bool = false
    var jobTitles = [JobTitle]()
    var location : Location! = Location()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SEARCH JOB"
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Private Methods
    func setup() {
        self.tblViewJobSearch.rowHeight = UITableViewAutomaticDimension
        self.tblViewJobSearch.register(UINib(nibName: "JobSeachTitleCell", bundle: nil), forCellReuseIdentifier: "JobSeachTitleCell")
        self.tblViewJobSearch.register(UINib(nibName: "JobSearchTypeCell", bundle: nil), forCellReuseIdentifier: "JobSearchTypeCell")
        self.tblViewJobSearch.register(UINib(nibName: "JobSearchPartTimeCell", bundle: nil), forCellReuseIdentifier: "JobSearchPartTimeCell")
        self.tblViewJobSearch.register(UINib(nibName: "CurrentLocationCell", bundle: nil), forCellReuseIdentifier: "CurrentLocationCell")
    }
}

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
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Blank")
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JobSeachTitleCell") as? JobSeachTitleCell
            cell?.selectionStyle = .none
            if cell == nil {
                cell = JobSeachTitleCell()
            }
            cell?.jobTitles = self.jobTitles
            cell!.updateJobTitle()
            return cell!
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchTypeCell") as? JobSearchTypeCell
                cell?.delegate = self
                cell?.selectionStyle = .none
                if cell == nil {
                    cell = JobSearchTypeCell()
                }
                return cell!
            }
            else if  indexPath.row == 1 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchPartTimeCell") as? JobSearchPartTimeCell
                cell?.delegate = self
                cell?.selectionStyle = .none
                if cell == nil {
                    cell = JobSearchPartTimeCell()
                }
                return cell!
            }
        }
        else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "CurrentLocationCell") as! CurrentLocationCell
                cell.selectionStyle = .none
                cell.lblLocation.text = self.location.address
                if cell == nil {
                    cell = CurrentLocationCell()
                }
                return cell
            }
            else if  indexPath.row == 1 {
                return cell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 189.0
            }
            else if indexPath.row == 1 {
                return 76.0
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return UITableViewAutomaticDimension
            }
            else if indexPath.row == 1 {
                return self.tblViewJobSearch.frame.size.height - (88 + 189 + 77 + 88)
            }
        }
        return 0
    }
    
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 88.0
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 189.0
            }
            else if indexPath.row == 1 {
                return 76.0
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 88.0
            }
            else if indexPath.row == 1 {
                return self.tblViewJobSearch.frame.size.height - (88 + 189 + 77 + 88)
            }
        }
        return 0
    }
    
    func tableView( _ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        // To Add Search Button
        let footerView = UIView(frame: CGRect(x : 0.0, y : 0.0, width : tableView.frame.size.width,height : 49.0))
        footerView.backgroundColor = UIColor.init(colorLiteralRed: 4.0/255.0, green: 112.0/255.0, blue: 192.0/255.0, alpha: 1.0)
        
        let btnSearch = UIButton.init(frame: CGRect(x : 0 , y : 0, width : footerView.frame.size.width, height : footerView.frame.size.height))
        btnSearch.setTitle("SEARCH", for: .normal)
        btnSearch.setTitleColor(UIColor.white, for: .normal)
        btnSearch.titleLabel!.font =  UIFont.fontSemiBold(fontSize: 16.0)
        btnSearch.backgroundColor = UIColor.clear
        btnSearch.addTarget(self, action: #selector(actionSearchButton), for: .touchUpInside)
        footerView.addSubview(btnSearch)
        
        return footerView
    }
    
     func tableView( _ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else if section == 1 {
            return 0
        }
        else if section == 2 {
            
            return 49.0
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
            }
            else if indexPath.row == 1 {
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let registerMapsVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegisterMapsVC.self)!
                registerMapsVC.delegate = self
                self.navigationController?.pushViewController(registerMapsVC, animated: true)
            }
            else if indexPath.row == 1 {
            }
        }
    }
    
    //MARK : Action Search Method
    
    func actionSearchButton() {
        let jobSearchResultVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobSearchResultVC.self)!
        self.navigationController?.pushViewController(jobSearchResultVC, animated: true)
    }
}

extension DMJobSearchVC : JobSearchTypeCellDelegate, JobSearchPartTimeCellDelegate {
    
    //MARK : JobSearchTypeCellDelegate Method
    
    func selectJobSearchType(selected: Bool, type: String) {
        if type ==  JobSearchType.PartTime.rawValue {
            if selected == true  {
                if isPartTimeDayShow == false {
                    isPartTimeDayShow = !isPartTimeDayShow
                    tblViewJobSearch.beginUpdates()
                    tblViewJobSearch.insertRows(at: [IndexPath(row: 1, section: 1)], with: .top )
                    tblViewJobSearch.endUpdates()
                }
            }
            else {
                isPartTimeDayShow = !isPartTimeDayShow
                tblViewJobSearch.beginUpdates()
                tblViewJobSearch.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .top)
                tblViewJobSearch.endUpdates()
            }
        }
        else {
            
        }
    }
    
    //MARK : JobSearchPartTimeCellDelegate Method
    
    func selectDay(selected: Bool, day: String) {
        
    }
}

extension DMJobSearchVC : DMJobTitleVCDelegate {
    
    func setSelectedJobType(jobTitles: [JobTitle]) {
        self.jobTitles.removeAll()
        self.jobTitles = jobTitles
        tblViewJobSearch.beginUpdates()
        tblViewJobSearch.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tblViewJobSearch.endUpdates()
    }
}

extension DMJobSearchVC : LocationAddressDelegate {
    
    func locationAddress(location: Location) {
        
        self.location = location
        if location.address != nil {
                tblViewJobSearch.beginUpdates()
                tblViewJobSearch.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
                tblViewJobSearch.endUpdates()
            debugPrint(self.location.address ?? "Address not found")
        }
        else {
            debugPrint("Address is empty")
        }
        
    }
}
