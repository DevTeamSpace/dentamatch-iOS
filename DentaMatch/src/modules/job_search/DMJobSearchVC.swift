import CoreLocation
import GoogleMaps
import GooglePlaces
import UIKit

protocol SearchJobDelegate:class {
    func refreshJobList()
}

class DMJobSearchVC: DMBaseVC {
    @IBOutlet var tblViewJobSearch: UITableView!
    
    weak var delegate: SearchJobDelegate?
    
    var isPartTimeDayShow: Bool = false
    var jobTitles = [JobTitle]()
    var preferredLocations = [PreferredLocation]()
    var partTimeJobDays = [String]()
    var location: Location! = Location()
    var isJobTypeFullTime: String! = "0"
    var isJobTypePartTime: String! = "0"
    var searchParams = [String: Any]()
    var fromJobSearchResults = false
    var firstTime = false

    var city = ""
    var country = ""
    var state = ""

    enum TableViewCellHeight: CGFloat {
        case jobTitleAndLocation = 88.0
        case jobType = 189.0
        case jobTypePartTime = 76.0
    }
    
    var viewOutput: DMJobSearchViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.ScreenTitleNames.jobSearch
        
        viewOutput?.didLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstTime {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - @IBAction Method

    @IBAction func actionSearchButton(_: UIButton) {
        if validateFields() {
            actionSearchButton()
        }
    }

    // MARK: - Private Methods

    func setup() {
        if let params = UserDefaultsManager.sharedInstance.loadSearchParameter() {
            searchParams = params
            if searchParams[Constants.JobDetailKey.isParttime] as? String ?? "" == "1" {
                isPartTimeDayShow = true
                isJobTypePartTime = "1"
                partTimeJobDays = searchParams[Constants.JobDetailKey.parttimeDays] as? [String] ?? []
            } else {
                isJobTypePartTime = "0"
            }
            if searchParams[Constants.JobDetailKey.isFulltime] as? String ?? "" == "1" {
                isJobTypeFullTime = "1"
            } else {
                isJobTypeFullTime = "0"
            }

            jobTitles.removeAll()
            if let savedJobTitles = searchParams[Constants.JobDetailKey.jobTitles] as? [Any] {
                for title in savedJobTitles {
                    if let objTilte = title as? [String: Any] {
                        let jobTitle = JobTitle()
                        jobTitle.jobId = Int(objTilte[Constants.ServerKey.jobId] as? String ?? "0")!
                        jobTitle.jobTitle = objTilte[Constants.ServerKey.jobtitleName] as? String ?? ""
                        jobTitle.jobSelected = true
                        jobTitles.append(jobTitle)
                    }
                    
                }
            }

            preferredLocations.removeAll()
            if let savedPreferredLocations = searchParams["preferredJobLocations"] as? [Any] {
                for location in savedPreferredLocations {
                    if let objTilte = location as? [String: Any] {
                        let preferredLocation = PreferredLocation()
                        preferredLocation.id = objTilte["id"] as? String ?? "0"
                        preferredLocation.preferredLocationName = objTilte["preferredLocationName"] as? String ?? ""
                        preferredLocation.isSelected = true
                        preferredLocations.append(preferredLocation)
                    }
                }
            }
        } else {
            // self.getLocation()
        }


        if fromJobSearchResults {
            navigationItem.leftBarButtonItem = backBarButton()
            if let params = UserDefaultsManager.sharedInstance.loadSearchParameter() {
                searchParams = params
            }
        } else {
            navigationItem.leftBarButtonItem = nil
        }

        tblViewJobSearch.rowHeight = UITableView.automaticDimension
        tblViewJobSearch.register(UINib(nibName: "JobSeachTitleCell", bundle: nil), forCellReuseIdentifier: "JobSeachTitleCell")
        tblViewJobSearch.register(UINib(nibName: "JobSearchTypeCell", bundle: nil), forCellReuseIdentifier: "JobSearchTypeCell")
        tblViewJobSearch.register(UINib(nibName: "JobSearchPartTimeCell", bundle: nil), forCellReuseIdentifier: "JobSearchPartTimeCell")
        tblViewJobSearch.register(UINib(nibName: "CurrentLocationCell", bundle: nil), forCellReuseIdentifier: "CurrentLocationCell")
    }

    func validateFields() -> Bool {
        if jobTitles.count == 0 {
            makeToast(toastString: Constants.AlertMessage.selectTitle)
            return false
        }
        if isJobTypeFullTime == "0" && isJobTypePartTime == "0" {
            makeToast(toastString: Constants.AlertMessage.selectOneAvailableOption)
            return false
        }
        if isJobTypePartTime == "1" && partTimeJobDays.count == 0 {
            makeToast(toastString: Constants.AlertMessage.selectAvailableDay)
            return false
        }

        return true
    }

    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { (response: GMSReverseGeocodeResponse?, _: Error?) in
            if let address = response?.firstResult() {
                let lines = address.lines!
                let count = response?.results()?.count

                if let state = address.administrativeArea {
                    self.state = state
                }

                if let city = address.locality {
                    self.city = city
                }

                if let country = address.country {
                    self.country = country
                }

                for i in 0 ..< count! {
                    if let postalCode = response?.results()![i].postalCode {
                        self.location.postalCode = postalCode
                        break
                    }
                }
                // debugPrint(lines.joined(separator: " "))
                self.location.address = lines.joined(separator: " ")
                DispatchQueue.main.async {
                    if self.location.address != nil {
                        self.tblViewJobSearch.beginUpdates()
                        self.tblViewJobSearch.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .bottom)
                        self.tblViewJobSearch.endUpdates()
                        self.tblViewJobSearch.scrollToRow(at: IndexPath(row: 0, section: 2), at: UITableView.ScrollPosition.none, animated: false)
                        // debugPrint(self.location.address ?? "Address not found")
                    } else {
                        // debugPrint("Address is empty")
                    }
                }
            }
        }
    }

    func actionSearchButton() {
        view.endEditing(true)
        var jobTitles = [Any]()
        var preferredLocationsArray = [Any]()
        var jobTitleIds = [Int]()
        var preferredLocationIds = [String]()

        for job in self.jobTitles {
            let dict = NSMutableDictionary()
            dict.setObject(job.jobTitle, forKey: Constants.ServerKey.jobtitleName as NSCopying)
            dict.setObject("\(job.jobId)", forKey: Constants.ServerKey.jobId as NSCopying)

            jobTitles.append(dict)
        }

        for location in preferredLocations {
            let dict = NSMutableDictionary()
            dict.setObject(location.preferredLocationName, forKey: "preferredLocationName" as NSCopying)
            dict.setObject(location.id, forKey: "id" as NSCopying)
            preferredLocationsArray.append(dict)
        }

        for job in self.jobTitles {
            jobTitleIds.append(job.jobId)
        }

        for location in preferredLocations {
            preferredLocationIds.append(location.id)
        }
        searchParams[Constants.JobDetailKey.isFulltime] = isJobTypeFullTime
        searchParams[Constants.JobDetailKey.isParttime] = isJobTypePartTime
        searchParams[Constants.JobDetailKey.parttimeDays] = partTimeJobDays
        searchParams[Constants.JobDetailKey.jobTitle] = jobTitleIds
        searchParams[Constants.JobDetailKey.jobTitles] = jobTitles
        searchParams[Constants.JobDetailKey.page] = 1
        searchParams["preferredJobLocations"] = preferredLocationsArray
        searchParams["preferredJobLocationId"] = preferredLocationIds

        viewOutput?.goToSearchResult(params: searchParams)
    }
}

extension DMJobSearchVC: DMJobSearchViewInput {
    
    func configureView(fromJobSelection: Bool, delegate: SearchJobDelegate?) {
        self.fromJobSearchResults = fromJobSelection
        self.delegate = delegate
    }
}
