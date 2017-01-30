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
        self.restoreAllMarkers()
        self.mapViewSearchResult.animate(to: GMSCameraPosition(target: self.currentCoordinate, zoom: 15, bearing: 0, viewingAngle: 0))
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let marker = marker as! JobMarker
        self.moveToMarker(marker: marker)
        return false
    }
    
    func moveToMarker(marker: JobMarker) {
        let objJobSearch =  Job.init()
        objJobSearch.jobId = marker.job_id!
        
        //let arrIDs = self.arrMarkers.valueForKey("user_id")
        //let index = arrIDs.indexOfObject(marker.user_id!)
        
        self.mapViewSearchResult.animate(to: GMSCameraPosition(target: self.currentCoordinate, zoom: 15, bearing: 0, viewingAngle: 0))
    }
    
    func restoreAllMarkers() {
        for objJobSearch in self.jobSearchResult {
            let latStr = objJobSearch.latitude as NSString
            let latDbl : Double  = Double(latStr.intValue)
            let langStr = objJobSearch.longitude as NSString
            let langDbl : Double = Double(langStr.intValue)
            //var location = CLLocationCoordinate2D(latitude : latDbl, longitude : langDbl)
            let marker = JobMarker()
            marker.job_id = objJobSearch.jobId
            marker.isDraggable = false
            marker.position = CLLocationCoordinate2DMake(latDbl,langDbl )
            marker.icon = UIImage(named: "pinPoint")
            marker.map = self.mapViewSearchResult
            //self.mapViewSearchResult.animate(to: GMSCameraPosition(target: self.currentCoordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        }
    }
    
}
