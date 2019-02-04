import Foundation
import GoogleMaps

extension DMJobSearchResultVC: GMSMapViewDelegate {
    func mapView(_: GMSMapView, didTapAt _: CLLocationCoordinate2D) {
        // Just hiding the card and restoring markers.
        // self.restoreAllMarkers()
        deselectMarker()
        hideCard()
    }

    func mapView(_: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let marker = marker as? JobMarker else { return false }
        if let index = indexOfSelectedMarker {
            if marker.index != index {
                deselectMarker()
            }
        }
        marker.icon = UIImage(named: "mapLPin")
        indexOfSelectedMarker = marker.index
        selectedMarker = marker
        showCard(index: marker.index!)
        return true
    }

    func moveToMarker(marker: JobMarker) {
        mapViewSearchResult.selectedMarker = marker
    }

    func deselectMarker() {
        if let marker = self.selectedMarker {
            marker.icon = UIImage(named: "pinPoint")
        }
        indexOfSelectedMarker = nil
        selectedMarker = nil
    }

    func restoreAllMarkers() {
        mapViewSearchResult.selectedMarker = nil
        mapViewSearchResult.clear()
        for (index, objJob) in (viewOutput?.jobs ?? []).enumerated() {
            let latStr = objJob.latitude as NSString
            let latDbl: Double = Double(latStr.doubleValue)
            let langStr = objJob.longitude as NSString
            let langDbl: Double = Double(langStr.doubleValue)
            let marker = JobMarker()
            marker.index = index
            marker.isDraggable = false
//            marker.panoramaView
            marker.position = CLLocationCoordinate2DMake(latDbl, langDbl)
            marker.icon = UIImage(named: "pinPoint")
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.map = mapViewSearchResult
            if index == 0 {
                mapViewSearchResult.animate(to: GMSCameraPosition(target: CLLocationCoordinate2DMake(latDbl, langDbl), zoom: 10, bearing: 0, viewingAngle: 0))
            }
        }
    }

    func showCard(index: Int) {
        tblJobSearchResult.isHidden = false
        constraintTblViewSearchResultHeight.constant = cellHeight
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (_: Bool) in
            DispatchQueue.main.async {
                self.tblJobSearchResult.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
                self.tblJobSearchResult.isScrollEnabled = false
            }
        }
    }

    func hideCard() {
        tblJobSearchResult.isHidden = true
        constraintTblViewSearchResultHeight.constant = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (_: Bool) in
            self.tblJobSearchResult.isScrollEnabled = true
        }
    }
}
