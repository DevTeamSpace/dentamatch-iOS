//
//  DMJobSearchResultVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMaps

class DMJobSearchResultVC : DMBaseVC {

    @IBOutlet weak var tblJobSearchResult: UITableView!
    @IBOutlet weak var mapViewSearchResult: GMSMapView!
    @IBOutlet weak var constraintTblViewSearchResultTop: NSLayoutConstraint!
    
    
    var rightBarBtn : UIButton = UIButton()
    var rightBarButtonItem : UIBarButtonItem = UIBarButtonItem()
    var isListShow : Bool = true
    var isMapShow : Bool = false
    var btnList : UIButton!
    var btnMap : UIButton!
    var currentCoordinate : CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude : 0.00, longitude : 0.00)
    var arrMarkers  = [JobDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : Private Method
    
    func setUp() {
        self.mapViewSearchResult.isHidden = true
        self.tblJobSearchResult.rowHeight = UITableViewAutomaticDimension
        self.tblJobSearchResult.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")
        self.setLeftBarButton()
        self.setRightBarButton()
        self.setUpSegmentControl()
        self.mapViewSearchResult.delegate = self
        self.mapViewSearchResult.isMyLocationEnabled = true
        self.arrMarkers = [JobDetails]()
        let objMarker = JobDetails(JobDetails: "")
        objMarker.latitude = "28.5006637"
        objMarker.latitude = "77.0687053"
        self.arrMarkers.append(objMarker)
        objMarker.latitude = "28.5006637"
        objMarker.latitude = "77.0687053"
        self.arrMarkers.append(objMarker)
    }
    
    //MARK : Setup Left Bar Button
    override func setLeftBarButton()  {
        var leftBarBtn : UIButton = UIButton()
        var leftBarButtonItem : UIBarButtonItem = UIBarButtonItem()
        leftBarBtn = UIButton()
        leftBarBtn.titleLabel?.font = UIFont.designFont(fontSize: 22.0)
        leftBarBtn.titleLabel?.textColor = UIColor.white
        leftBarBtn.setTitle("a", for: .normal)
        leftBarBtn.frame = CGRect(x : 0,y : 0,width: 25,height : 25)
        leftBarBtn.imageView?.contentMode = .scaleAspectFit
        leftBarBtn.addTarget(self, action: #selector(DMJobSearchResultVC.actionLeftNavigationItem), for: .touchUpInside)
        leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = leftBarBtn
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func setRightBarButton()  {
        self.rightBarBtn = UIButton()
        self.rightBarBtn.setTitle("y", for: .normal)
        self.rightBarBtn.titleLabel?.font = UIFont.designFont(fontSize: 22.0)
        self.rightBarBtn.frame = CGRect(x : 0,y : 0,width: 25,height : 25)
        self.rightBarBtn.imageView?.contentMode = .scaleAspectFit
        self.rightBarBtn.addTarget(self, action: #selector(DMJobSearchResultVC.actionRightNavigationItem), for: .touchUpInside)
        self.rightBarButtonItem = UIBarButtonItem()
        self.rightBarButtonItem.customView = self.rightBarBtn
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    override func actionLeftNavigationItem() {
        
    }
    
    func actionRightNavigationItem() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpSegmentControl() {
        let segmentView : UIView! = UIView(frame:CGRect (x : 0,y : 0, width : 152,height : 29))
        segmentView.backgroundColor = UIColor.clear
        segmentView.layer.cornerRadius = 4.0
        segmentView.layer.borderColor = UIColor.init(red: 42/255.0, green: 85/255.0, blue: 169.0/255.0, alpha: 1.0).cgColor
        segmentView.layer.borderWidth = 1.0
        segmentView.layer.masksToBounds = true
        
        self.btnList = UIButton.init(frame: CGRect(x : 0 , y : 1, width : 75, height : 27))
        self.btnList.setTitle("List", for: .normal)
        self.btnList.setTitleColor(UIColor.white, for: .normal)
        self.btnList.titleLabel!.font =  UIFont.fontLight(fontSize: 13.0)
        self.btnList.backgroundColor = UIColor.init(red: 4/255.0, green: 112/255.0, blue: 191.0/255.0, alpha: 1.0)
        self.btnList.addTarget(self, action: #selector(actionListButton), for: .touchUpInside)
        
        self.btnMap = UIButton.init(frame: CGRect(x : 76 , y : 1, width : 75, height : 27))
        self.btnMap.setTitle("Map", for: .normal)
        self.btnMap.setTitleColor(UIColor.white, for: .normal)
        self.btnMap.titleLabel!.font =  UIFont.fontLight(fontSize: 13.0)
        self.btnMap.backgroundColor = UIColor.clear
        self.btnMap.layer.masksToBounds = true
        self.btnMap.addTarget(self, action: #selector(actionMapButton), for: .touchUpInside)
        segmentView.addSubview(self.btnList)
        segmentView.addSubview(btnMap)
        self.navigationItem.titleView = segmentView
    }
    
    func actionListButton() {
        if isListShow == false {
            self.btnList.backgroundColor = UIColor.init(red: 4/255.0, green: 112/255.0, blue: 191.0/255.0, alpha: 1.0)
            self.btnList.titleLabel!.font =  UIFont.fontSemiBold(fontSize: 13.0)
            self.btnMap.titleLabel!.font =  UIFont.fontLight(fontSize: 13.0)
            self.btnMap.backgroundColor = UIColor.clear
            self.mapViewSearchResult.isHidden = true
        }
        isListShow = !isListShow
    }
    
    func actionMapButton() {
        if isMapShow == false {
            self.btnMap.backgroundColor = UIColor.init(red: 4/255.0, green: 112/255.0, blue: 191.0/255.0, alpha: 1.0)
            self.btnMap.titleLabel!.font =  UIFont.fontSemiBold(fontSize: 13.0)
            self.btnList.titleLabel!.font =  UIFont.fontLight(fontSize: 13.0)
            self.btnList.backgroundColor = UIColor.clear
            self.mapViewSearchResult.isHidden = false
        }
        self.getLocation()
        self.restoreAllMarkers()
    }
    
    func getLocation() {
        LocationManager.sharedInstance.getLocation { (location:CLLocation?, error:NSError?) in
            if error != nil {
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.alertMessage(title: "", message: (error?.localizedDescription)!, buttonText: kOkButtonTitle, completionHandler: nil)
                }
                return
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: (location!.coordinate.latitude), longitude: (location!.coordinate.longitude))
            self.currentCoordinate = coordinate
            DispatchQueue.main.async {
                self.hideLoader()
                self.mapViewSearchResult.animate(to: GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0))
            }
        }
    }
}

extension DMJobSearchResultVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchResultCell") as! JobSearchResultCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 189.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDetailVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobDetailVC.self)!
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
    }
}

extension DMJobSearchResultVC : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // Just hiding the card and restoring markers.
        self.restoreAllMarkers()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let marker = marker as! JobMarker
        self.moveToMarker(marker: marker)
        return false
    }
    
    func moveToMarker(marker: JobMarker) {
        
    }
    
    func restoreAllMarkers() {
        for objMarker in self.arrMarkers {
            let latStr = objMarker.latitude as NSString
            let latDbl : Double  = Double(latStr.intValue)
            let langStr = objMarker.longitude as NSString
            let langDbl : Double = Double(langStr.intValue)
            var location = CLLocationCoordinate2D(latitude : latDbl, longitude : langDbl)
            var marker = JobMarker()
            marker.isDraggable = false
            marker.position = CLLocationCoordinate2DMake(latDbl,langDbl )
            marker.icon = UIImage(named: "pinPoint")
            marker.map = self.mapViewSearchResult
            self.mapViewSearchResult.animate(to: GMSCameraPosition(target: self.currentCoordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        }
    }
    
}
