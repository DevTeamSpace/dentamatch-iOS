import Foundation
import UIKit
import GoogleMaps

class JobSearchMapScreenView: UIView {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var jobMapDetailView: JobMapDetailView! {
        didSet {
            jobMapDetailView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            jobMapDetailView.layer.shadowOffset = CGSize(width: 0, height: -1)
            jobMapDetailView.layer.shadowOpacity = 1.0
            jobMapDetailView.layer.shadowRadius = 2
        }
    }
    @IBOutlet weak var detailViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentLocationButton: UIButton! {
        didSet {
            currentLocationButton.layer.cornerRadius = currentLocationButton.frame.height / 2
            currentLocationButton.layer.shadowColor = UIColor.gray.cgColor
            currentLocationButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            currentLocationButton.layer.shadowOpacity = 1.0
            currentLocationButton.layer.shadowRadius = 1.0
        }
    }
}
