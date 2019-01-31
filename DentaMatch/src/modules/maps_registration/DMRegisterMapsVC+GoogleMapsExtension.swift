import Foundation
import GoogleMaps
import GooglePlaces

extension DMRegisterMapsVC: GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate {
    func viewController(_: GMSAutocompleteViewController, didAutocompleteWith _: GMSPlace) {
    }

    func viewController(_: GMSAutocompleteViewController, didFailAutocompleteWithError _: Error) {
        
    }

    func viewController(_: GMSAutocompleteViewController, didSelect _: GMSAutocompletePrediction) -> Bool {
        return true
    }

    func wasCancelled(_: GMSAutocompleteViewController) {
        
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
