//
//  DMRegisterMapsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol LocationAddressDelegate {
    func locationAddress(address:String?,coordinate:CLLocationCoordinate2D?)
}

class DMRegisterMapsVC: DMBaseVC {

    @IBOutlet weak var gpsNavigationButton: UIButton!
    @IBOutlet weak var placeSearchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placesTableView: UITableView!

    var placesArray = [GMSAutocompletePrediction]()
    var marker:GMSMarker?
    var coordinateSelected:CLLocationCoordinate2D?
    var currentLocation:CLLocationCoordinate2D?
    var addressSelected = ""
    var delegate:LocationAddressDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideLoader()
    }
    
    func setup() {
        self.gpsNavigationButton.layer.cornerRadius = self.gpsNavigationButton.frame.size.width/2
        self.gpsNavigationButton.layer.shadowColor = UIColor.gray.cgColor;
        self.gpsNavigationButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.gpsNavigationButton.layer.shadowOpacity = 1.0;
        self.gpsNavigationButton.layer.shadowRadius = 1.0;
        
        self.placesTableView.rowHeight = UITableViewAutomaticDimension
        self.placesTableView.estimatedRowHeight = 50
        self.placesTableView.isHidden = true
        self.placesTableView.backgroundColor = UIColor.clear
        self.placesTableView.tableFooterView = UIView(frame: CGRect.zero)
        setSearchButtonText(text: "Done", searchBar: placeSearchBar)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        self.showLoader(text: "Getting Location")
        LocationManager.sharedInstance.getLocation { (location:CLLocation?, error:NSError?) in
            if error != nil {
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.alertMessage(title: "", message: (error?.localizedDescription)!, buttonText: kOkButtonTitle, completionHandler: nil)
                }
                return
            }
           
            let coordinate = CLLocationCoordinate2D(latitude: (location!.coordinate.latitude), longitude: (location!.coordinate.longitude))
            self.coordinateSelected = coordinate
            self.currentLocation = coordinate
            self.reverseGeocodeCoordinate(coordinate: coordinate)
            DispatchQueue.main.async {
                self.hideLoader()
                self.mapView.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            }
        }
    }
    
    func setSearchButtonText(text:String,searchBar:UISearchBar) {
        for subview in searchBar.subviews {
            for innerSubViews in subview.subviews {
                if innerSubViews is UIButton {
                    if let cancelButton = innerSubViews as? UIButton {
                        cancelButton.setTitleColor(UIColor.white, for: .normal)
                        cancelButton.setTitle(text, for: .normal)
                    }
                }
            }
        }
    }
    
    func placeAutocomplete(autoCompleteString:NSString) {
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        let placesClient = GMSPlacesClient()
        
        placesClient.autocompleteQuery(autoCompleteString as String, bounds: nil, filter: filter) { (results:[GMSAutocompletePrediction]?, error:Error?) in
            
            if error != nil {
                debugPrint(error.debugDescription)
                return
            }
            
            if self.placesArray.count > 0 {
                self.placesArray.removeAll()
            }
            
            for result in results! {
                self.placesArray.append(result)
            }
            self.placesTableView.reloadData()
        }
    }
    
    func getPlaceDetails(_ prediction:GMSAutocompletePrediction) {
        let placesClient = GMSPlacesClient()
        //let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(prediction.placeID!) { (place:GMSPlace?, error:Error?) in
            if error != nil {
                return
            }
            if let place = place {
                debugPrint(place)
                OperationQueue.main.addOperation({
                    self.placeMarkerOnMap(coordinate: place.coordinate, isAnimatingToLocation: true)
                })
            } else {
            }
        }
    }
    
    func placeMarkerOnMap(coordinate:CLLocationCoordinate2D,isAnimatingToLocation:Bool = false) {
        if marker == nil {
            marker = GMSMarker()
            marker?.isDraggable = true
        }
        marker?.position = coordinate
        //marker.icon = GMSMarker.markerImage(with: UIColor.black)
        //marker.icon = UIImage(named:"ic_pin")
        marker?.map = self.mapView
        marker?.appearAnimation = kGMSMarkerAnimationPop
        if isAnimatingToLocation {
        self.mapView.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        }
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { (response:GMSReverseGeocodeResponse?, error:Error?) in
            if let address = response?.firstResult() {
//                self.placeMarkerOnMap(coordinate: address.coordinate)
                let lines = address.lines!
                let count = response?.results()?.count
                
                for i in 0..<(count)! {
                    if let postalCode = response?.results()![i].postalCode {
                        //self.selectedpostalCode =  postalCode
                        break
                    }
                }
                print(lines.joined(separator: "\n"))
                self.placeSearchBar.text = lines.joined(separator: "\n")

                DispatchQueue.main.async {
                    self.placeSearchBar.text = lines.joined(separator: "\n")
                }
            }
        }
    }
    @IBAction func gpsNavigationButtonPressed(_ sender: Any) {
    }
}

//MARK:- GoogleMaps Autocomplete Delegates
extension DMRegisterMapsVC:GMSAutocompleteViewControllerDelegate,GMSMapViewDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        self.placeMarkerOnMap(coordinate: coordinate)
        reverseGeocodeCoordinate(coordinate: coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        reverseGeocodeCoordinate(coordinate: marker.position)
    }
}

//MARK:- SearchBar Delegates
extension DMRegisterMapsVC:UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let delegate = self.delegate {
            self.addressSelected = self.placeSearchBar.text!
            delegate.locationAddress(address: addressSelected, coordinate: coordinateSelected)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.placesTableView.isHidden = true
        } else {
            self.placesTableView.isHidden = false
        }
        
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        self.present(autocompleteController, animated: true, completion: nil)
        placeAutocomplete(autoCompleteString: searchText as NSString)
    }
}

extension DMRegisterMapsVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GooglePlacesTableViewCell") as! GooglePlacesTableViewCell
        let place = placesArray[indexPath.row]
        cell.placeLabel.attributedText = place.attributedFullText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = placesArray[indexPath.row]
        getPlaceDetails(place)
        self.placeSearchBar.text = place.attributedFullText.string
        self.placesTableView.isHidden = true
    }
}
