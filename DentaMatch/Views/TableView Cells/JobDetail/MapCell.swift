//
//  MapCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMaps

class MapCell: UITableViewCell {

    @IBOutlet weak var mapView: GMSMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mapView.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setPinOnMap(job : Job) {
        self.mapView.clear()
        let latStr = job.latitude as NSString
        let latDbl : Double  = Double(latStr.intValue)
        let langStr = job.longitude as NSString
        let langDbl : Double = Double(langStr.intValue)
        let marker = JobMarker()
        marker.isDraggable = false
        marker.position = CLLocationCoordinate2DMake(latDbl,langDbl )
        marker.icon = UIImage(named: "mapPin")
        marker.map = self.mapView
        self.mapView.animate(to: GMSCameraPosition(target: CLLocationCoordinate2DMake(latDbl,langDbl ), zoom: 15, bearing: 0, viewingAngle: 0))
    }

}
