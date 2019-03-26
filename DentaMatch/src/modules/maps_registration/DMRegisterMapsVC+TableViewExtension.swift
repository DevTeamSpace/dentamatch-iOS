import Foundation

extension DMRegisterMapsVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return placesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GooglePlacesTableViewCell") as! GooglePlacesTableViewCell
        let place = placesArray[indexPath.row]
        cell.placeLabel.attributedText = place.attributedFullText
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = placesArray[indexPath.row]
        getPlaceDetails(place)
        placeSearchBar.text = place.attributedFullText.string
        location.address = place.attributedFullText.string
        placesTableView.isHidden = true
    }
}
