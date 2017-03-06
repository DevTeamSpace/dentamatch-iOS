//
//  DMJobSearchResultVC+GMSExtension.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps

extension DMJobSearchResultVC : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // Just hiding the card and restoring markers.
        //self.restoreAllMarkers()
        self.deselectMarker()
        self.hideCard()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let marker = marker as! JobMarker
        
        if let index = indexOfSelectedMarker {
            if marker.index != index {
                deselectMarker()
            }
        }
        marker.icon = UIImage(named: "mapLPin")
        self.indexOfSelectedMarker = marker.index
        self.selectedMarker = marker
        self.showCard(index: marker.index!)
        return true
    }
    
    func moveToMarker(marker: JobMarker) {
        self.mapViewSearchResult.selectedMarker = marker
    }
    
    func deselectMarker() {
        if let marker = self.selectedMarker {
            marker.icon = UIImage(named: "pinPoint")
        }
        self.indexOfSelectedMarker = nil
        self.selectedMarker = nil
    }
    
    func restoreAllMarkers() {
        self.mapViewSearchResult.selectedMarker = nil
        self.mapViewSearchResult.clear()
        for (index, objJob) in self.jobs.enumerated() {
            let latStr = objJob.latitude as NSString
            let latDbl : Double  = Double(latStr.doubleValue)
            let langStr = objJob.longitude as NSString
            let langDbl : Double = Double(langStr.doubleValue)
            let marker = JobMarker()
            marker.index = index
            marker.isDraggable = false
            marker.position = CLLocationCoordinate2DMake(latDbl,langDbl )
            marker.icon = UIImage(named: "pinPoint")
            marker.map = self.mapViewSearchResult
            if index == 1  {
                self.mapViewSearchResult.animate(to: GMSCameraPosition(target: CLLocationCoordinate2DMake(latDbl,langDbl), zoom: 10, bearing: 0, viewingAngle: 0))
            }
        }
    }
    
    func showCard(index : Int) {
        self.constraintTblViewSearchResultHeight.constant = cellHeight
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (complete: Bool) in
            DispatchQueue.main.async {
                self.tblJobSearchResult.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
                self.tblJobSearchResult.isScrollEnabled = false
            }
        }
    }
    
    func hideCard() {
        self.constraintTblViewSearchResultHeight.constant = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (complete: Bool) in
            self.tblJobSearchResult.isScrollEnabled = true        }
    }
}
