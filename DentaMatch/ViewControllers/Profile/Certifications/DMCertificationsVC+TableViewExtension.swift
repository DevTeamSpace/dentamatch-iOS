//
//  DMCertificationsVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMCertificationsVC: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let certificationOption = Certifications(rawValue: section)!

        switch certificationOption {
        case .profileHeader:
            return 1
        case .certifications:
            return certicates.count
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let certificationOption = Certifications(rawValue: indexPath.section)!

        switch certificationOption {
        case .profileHeader:
            return 213
        case .certifications:
            return 350
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certificationOption = Certifications(rawValue: indexPath.section)!

        switch certificationOption {
        case .profileHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.updateCellForPhotoNameCell(nametext: "Update Certifications", jobTitleText: "Lorem Ipsum is simply dummy text for the typing and printing industry", profileProgress: profileProgress)
            return cell

        case .certifications:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CertificationsCell") as! CertificationsCell
            updateCellForCertification(cell: cell, indexPath: indexPath)
            return cell
        }
    }

    func updateCellForCertification(cell: CertificationsCell, indexPath: IndexPath) {
        let certificate = certicates[indexPath.row]
        cell.validityDateTextField.tag = indexPath.row
        cell.validityDateTextField.inputView = dateView
        cell.validityDateTextField.delegate = self
        cell.validityDateTextField.text = certificate.validityDate
        cell.headingLabel.text = certificate.certificationName
        cell.photoButton.tag = indexPath.row
        cell.photoButton.addTarget(self, action: #selector(DMCertificationsVC.certificationImageButtonPressed(_:)), for: .touchUpInside)
        if let imageURL = URL(string: certificate.certificateImageURL!) {
            cell.photoButton.sd_setImage(with: imageURL, for: .normal, placeholderImage: UIImage(named: ""))
        } else {
            if certificate.certificateImage != nil {
                cell.photoButton.setImage(certificate.certificateImage, for: .normal)
            } else {
                cell.photoButton.setImage(UIImage(named: ""), for: .normal)
            }
        }
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        // didSelect
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dateView?.getPreSelectedValues(dateString: textField.text!, curTag: textField.tag)
        // debugPrint("set Tag =\(textField.tag)")
        if let textField = textField as? PickerAnimatedTextField {
            textField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? PickerAnimatedTextField {
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
