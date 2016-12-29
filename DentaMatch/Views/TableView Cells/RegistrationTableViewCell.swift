//
//  RegistrationTableViewCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

@objc protocol LocationViewTappedDelegate {
    @objc optional func locationViewDidTap()
}

class RegistrationTableViewCell: UITableViewCell {

    @IBOutlet weak var helpHintLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var newPasswordTextField: RegistrationTextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var emailTextField: RegistrationTextField!
    @IBOutlet weak var nameTextField: RegistrationTextField!
    
    var delegate: LocationViewTappedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationView.layer.borderColor = kTextFieldColor.cgColor
        locationView.layer.borderWidth = 1.0
        locationView.layer.cornerRadius = 5.0
        helpHintLabel.text = "  ⓘ Help Recruiters to find you easily"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(locationViewTapped))
        self.locationView.addGestureRecognizer(tapGesture)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        nameTextField.leftViewLabel?.text = "m"
        emailTextField.leftViewLabel?.text = "f"
        newPasswordTextField.leftViewLabel?.text = "e"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func locationViewTapped() {
        if let delegate = self.delegate {
            delegate.locationViewDidTap!()
        }
    }
    
}
