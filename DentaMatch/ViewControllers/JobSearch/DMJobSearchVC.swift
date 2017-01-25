//
//  DMJobSearchVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 06/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class DMJobSearchVC : DMBaseVC {
    
    @IBOutlet weak var tblViewJobSearch: UITableView!
    var isPartTimeDayShow : Bool = false
    var jobTitles = [JobTitle]()
    var jobSearchResult = [JobSearchResultModel]()
    var partTimeJobDays = [String]()
    var location : Location! = Location()
    var isJobTypeFullTime : String! = "0"
    var isJobTypePartTime : String! = "0"
    var searchParams = [
        Constants.JobDetailKey.lat:"",
        Constants.JobDetailKey.lng:"",
        Constants.JobDetailKey.zipCode:"",
        Constants.JobDetailKey.isFulltime:"",
        Constants.JobDetailKey.isParttime:"",
        Constants.JobDetailKey.parttimeDays:[],
        Constants.JobDetailKey.jobTitle:[],
        Constants.JobDetailKey.page:""
        ] as [String : Any]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SEARCH JOB"
        self.setup()
        self.getLocation()
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
    
    
    @IBAction func actionSearchButton(_ sender: UIButton) {
        if self.validateFields() {
            self.actionSearchButton()
        }
    }
    
    func validateFields() -> Bool {
        if self.jobTitles.count > 0 {
            if self.isJobTypeFullTime == "1" || self.isJobTypePartTime == "1" {
                if self.isJobTypePartTime == "1" {
                    if self.partTimeJobDays.count > 0 {
                        if self.location.coordinateSelected != nil {
                            return true
                        }
                        else {
                            self.makeToast(toastString: "Please select job location")
                            return false
                        }
                    }
                    else {
                        self.makeToast(toastString: "Please select a day")
                        return false
                    }
                }
                return true
            }
            else {
                self.makeToast(toastString: "Please select job Type")
                return false
            }
        }
        else {
            self.makeToast(toastString: "Please select atleast one job title")
            return false
        }
        return false
    }
    
    func getLocation() {
        LocationManager.sharedInstance.getLocation { (location:CLLocation?, error:NSError?) in
            if error != nil {
                DispatchQueue.main.async {
                    //self.hideLoader()
                    self.alertMessage(title: "", message: (error?.localizedDescription)!, buttonText: kOkButtonTitle, completionHandler: nil)
                }
                return
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: (location!.coordinate.latitude), longitude: (location!.coordinate.longitude))
            self.location.coordinateSelected = coordinate
            self.reverseGeocodeCoordinate(coordinate: coordinate)
        }
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { (response:GMSReverseGeocodeResponse?, error:Error?) in
            if let address = response?.firstResult() {
                let lines = address.lines!
                let count = response?.results()?.count
                for i in 0..<(count)! {
                    if let postalCode = response?.results()![i].postalCode {
                        self.location.postalCode =  postalCode
                        break
                    }
                }
                print(lines.joined(separator: " "))
                self.location.address = lines.joined(separator: " ")
                DispatchQueue.main.async {
                    if self.location.address != nil {
                        self.tblViewJobSearch.beginUpdates()
                        self.tblViewJobSearch.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .bottom)
                        self.tblViewJobSearch.endUpdates()
                        self.tblViewJobSearch.scrollToRow(at: IndexPath(row: 0, section: 2), at: UITableViewScrollPosition.none, animated: false)
                        debugPrint(self.location.address ?? "Address not found")
                    }
                    else {
                        debugPrint("Address is empty")
                    }
                }
            }
        }
    }
    
    func goToSearchResult() {
        
        if self.jobSearchResult.count > 0 {
            let jobSearchResultVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobSearchResultVC.self)!
            jobSearchResultVC.jobSearchResult = self.jobSearchResult
            self.navigationController?.pushViewController(jobSearchResultVC, animated: true)
        }
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
            return 1
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
                cell?.setUp()
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
        self.view.endEditing(true)
        
        var jobTitleIds = [Int]()
        
        for job in jobTitles {
            jobTitleIds.append(job.jobId)
        }
        if location.coordinateSelected?.latitude != nil {
            searchParams[Constants.JobDetailKey.lat] = String(describing: location.coordinateSelected!.latitude)
        }
        if location.coordinateSelected?.longitude != nil {
            searchParams[Constants.JobDetailKey.lng] = String(describing: location.coordinateSelected!.longitude)
        }
        searchParams[Constants.JobDetailKey.zipCode] = location.postalCode
        searchParams[Constants.JobDetailKey.isFulltime] = self.isJobTypeFullTime
        searchParams[Constants.JobDetailKey.isParttime] = self.isJobTypePartTime
        searchParams[Constants.JobDetailKey.parttimeDays] = partTimeJobDays
        searchParams[Constants.JobDetailKey.jobTitle] = jobTitleIds
        searchParams[Constants.JobDetailKey.page] = 1
        
        self.fetchSearchResultAPI(params: searchParams)
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
                    tblViewJobSearch.insertRows(at: [IndexPath(row: 1, section: 1)], with: .none )
                    tblViewJobSearch.endUpdates()
                    tblViewJobSearch.scrollToRow(at: IndexPath(row: 1, section: 1), at: UITableViewScrollPosition.none, animated: false)
                }
                isJobTypePartTime = "1"
            }
            else {
                isPartTimeDayShow = !isPartTimeDayShow
                tblViewJobSearch.beginUpdates()
                tblViewJobSearch.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .none)
                tblViewJobSearch.endUpdates()
                tblViewJobSearch.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableViewScrollPosition.none, animated: false)
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
}

extension DMJobSearchVC : DMJobTitleVCDelegate {
    
    func setSelectedJobType(jobTitles: [JobTitle]) {
        self.jobTitles.removeAll()
        self.jobTitles = jobTitles
        tblViewJobSearch.beginUpdates()
        tblViewJobSearch.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        tblViewJobSearch.endUpdates()
    }
}

extension DMJobSearchVC : LocationAddressDelegate {
    
    func locationAddress(location: Location) {
        
        self.location = location
        if location.address != nil {
                tblViewJobSearch.beginUpdates()
                tblViewJobSearch.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .bottom)
                tblViewJobSearch.endUpdates()
            tblViewJobSearch.scrollToRow(at: IndexPath(row: 0, section: 2), at: UITableViewScrollPosition.none, animated: false)
            debugPrint(self.location.address ?? "Address not found")
        }
        else {
            debugPrint("Address is empty")
        }
        
    }
}
