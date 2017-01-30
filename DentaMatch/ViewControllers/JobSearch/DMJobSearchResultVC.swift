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
    @IBOutlet weak var lblResultCount: UILabel!
    
    var rightBarBtn : UIButton = UIButton()
    var rightBarButtonItem : UIBarButtonItem = UIBarButtonItem()
    var isListShow : Bool = true
    var isMapShow : Bool = false
    var btnList : UIButton!
    var btnMap : UIButton!
    var currentCoordinate : CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude : 0.00, longitude : 0.00)
    var arrMarkers  = [JobMarker]()
    var jobSearchResult = [Job]()
    var rightBarButtonWidth : CGFloat = 25.0
    
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
        self.mapViewSearchResult.delegate = self
        self.mapViewSearchResult.isMyLocationEnabled = true
        self.lblResultCount.text = String(self.jobSearchResult.count) + " " + Constants.Strings.resultsFound
        self.setLeftBarButton(title: Constants.DesignFont.notification)
        self.setRightBarButton(title: Constants.DesignFont.search, width : rightBarButtonWidth)
        self.setUpSegmentControl()
    }
    
    override func actionLeftNavigationItem() {
    }
    
    override func actionRightNavigationItem() {
        _ = self.navigationController?.popViewController(animated: true)
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
                self.mapViewSearchResult.animate(to: GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0))
            }
        }
    }
}
