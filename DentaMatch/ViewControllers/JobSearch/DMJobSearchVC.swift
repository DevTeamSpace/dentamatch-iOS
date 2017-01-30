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
    var jobSearchResult = [Job]()
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
    
    //MARK:- @IBAction Method
    @IBAction func actionSearchButton(_ sender: UIButton) {
        if self.validateFields() {
            self.actionSearchButton()
        }
    }
    
    //MARK:- Private Methods
    func setup() {
        self.tblViewJobSearch.rowHeight = UITableViewAutomaticDimension
        self.tblViewJobSearch.register(UINib(nibName: "JobSeachTitleCell", bundle: nil), forCellReuseIdentifier: "JobSeachTitleCell")
        self.tblViewJobSearch.register(UINib(nibName: "JobSearchTypeCell", bundle: nil), forCellReuseIdentifier: "JobSearchTypeCell")
        self.tblViewJobSearch.register(UINib(nibName: "JobSearchPartTimeCell", bundle: nil), forCellReuseIdentifier: "JobSearchPartTimeCell")
        self.tblViewJobSearch.register(UINib(nibName: "CurrentLocationCell", bundle: nil), forCellReuseIdentifier: "CurrentLocationCell")
    }
    
    func validateFields() -> Bool {
        if self.jobTitles.count == 0 {
            self.makeToast(toastString: "Please select atleast one job title")
            return false
        }
        if self.isJobTypeFullTime == "0" && self.isJobTypePartTime == "0" {
            self.makeToast(toastString: "Please select job Type")
            return false
        }
        if self.isJobTypePartTime == "1" && self.partTimeJobDays.count == 0 {
            self.makeToast(toastString: "Please select a day")
            return false
        }
        if self.location.coordinateSelected == nil {
            self.makeToast(toastString: "Please select job location")
            return false
        }
        return true
    }
    
    func getLocation() {
        LocationManager.sharedInstance.getLocation { (location:CLLocation?, error:NSError?) in
            if error != nil {
                DispatchQueue.main.async {
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
