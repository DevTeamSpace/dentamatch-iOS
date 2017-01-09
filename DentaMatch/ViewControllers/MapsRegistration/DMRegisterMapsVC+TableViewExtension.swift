//
//  DMRegisterMapsVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation


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
        self.location.address = place.attributedFullText.string
        self.placesTableView.isHidden = true
    }
}
