import Foundation
import UIKit
import GoogleMaps

class JobSearchMapScreenViewController: DMBaseVC, BaseViewProtocol {

    typealias ViewClass = JobSearchMapScreenView

    var viewOutput: JobSearchMapScreenViewOutput?
    
    var indexOfSelectedMarker: Int?
    var selectedMarker: JobMarker?
    var currentCoordinate: CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        viewOutput?.didLoad()
    }
    
    @IBAction func actionCurrentLocaton(_: UIButton) {
        //rootView.mapView.animate(to: GMSCameraPosition(target: currentCoordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        hideCard()
    }
}

extension JobSearchMapScreenViewController: JobSearchMapScreenViewInput {

    func reloadData() {
        restoreAllMarkers()
    }
    
    func updateDetailView(with job: Job, index: Int) {
        guard index == rootView.jobMapDetailView.currentIndex else { return }
        rootView.jobMapDetailView.updateWithJob(job, index: index)
    }
}

extension JobSearchMapScreenViewController: GMSMapViewDelegate {
    
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
        rootView.mapView.selectedMarker = marker
    }
    
    func deselectMarker() {
        if let marker = self.selectedMarker {
            marker.icon = UIImage(named: "pinPoint")
        }
        indexOfSelectedMarker = nil
        selectedMarker = nil
    }
    
    func restoreAllMarkers() {
        guard let viewOutput = viewOutput else { return }
        rootView.mapView.selectedMarker = nil
        rootView.mapView.clear()
        for (index, objJob) in viewOutput.jobs.enumerated() {
            let latStr = objJob.latitude as NSString
            let latDbl: Double = Double(latStr.doubleValue)
            let langStr = objJob.longitude as NSString
            let langDbl: Double = Double(langStr.doubleValue)
            let marker = JobMarker()
            marker.index = index
            marker.isDraggable = false
            marker.position = CLLocationCoordinate2DMake(latDbl, langDbl)
            marker.icon = UIImage(named: "pinPoint")
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.map = rootView.mapView
            if index == 0 {
                rootView.mapView.animate(to: GMSCameraPosition(target: CLLocationCoordinate2DMake(latDbl, langDbl), zoom: 10, bearing: 0, viewingAngle: 0))
            }
        }
    }
    
    func showCard(index: Int) {
        guard let jobs = viewOutput?.jobs else { return }
        
        rootView.jobMapDetailView.updateWithJob(jobs[index], index: index)
        
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.rootView.jobMapDetailView.layoutIfNeeded()
            self.rootView.detailViewTopConstraint.constant = -self.rootView.jobMapDetailView.frame.height
            self.rootView.layoutIfNeeded()
        }
    }
    
    func hideCard() {
        rootView.detailViewTopConstraint.constant = 0
        
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.rootView.layoutIfNeeded()
        }
    }
}

extension JobSearchMapScreenViewController {
    
    private func configureView() {
        rootView.mapView.delegate = self
        rootView.mapView.isMyLocationEnabled = false
        rootView.jobMapDetailView.delegate = viewOutput
    }
}
