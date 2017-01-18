//
//  DMRegisterMapsVC+GoogleMapsExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

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
        debugPrint("viewController")

    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        self.placeMarkerOnMap(coordinate: coordinate)
        self.location.coordinateSelected = coordinate
        reverseGeocodeCoordinate(coordinate: coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        self.location.coordinateSelected = marker.position
        reverseGeocodeCoordinate(coordinate: marker.position)
    }
}
