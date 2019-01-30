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

// MARK: - GoogleMaps Autocomplete Delegates

extension DMRegisterMapsVC: GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate {
    func viewController(_: GMSAutocompleteViewController, didAutocompleteWith _: GMSPlace) {
    }

    func viewController(_: GMSAutocompleteViewController, didFailAutocompleteWithError _: Error) {
        // debugPrint(error.localizedDescription)
    }

    func viewController(_: GMSAutocompleteViewController, didSelect _: GMSAutocompletePrediction) -> Bool {
        return true
    }

    func wasCancelled(_: GMSAutocompleteViewController) {
        // debugPrint("viewController")
    }

    func mapView(_: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        placeMarkerOnMap(coordinate: coordinate)
        location.coordinateSelected = coordinate
        reverseGeocodeCoordinate(coordinate: coordinate)
    }

    func mapView(_: GMSMapView, didEndDragging marker: GMSMarker) {
        location.coordinateSelected = marker.position
        reverseGeocodeCoordinate(coordinate: marker.position)
    }
}
