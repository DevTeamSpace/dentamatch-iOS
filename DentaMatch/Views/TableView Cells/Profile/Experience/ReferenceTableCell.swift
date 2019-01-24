//
//  ReferenceTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 03/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ReferenceTableCell: UITableViewCell {
    @IBOutlet var nameTextField: AnimatedPHTextField!
    @IBOutlet var mobileNoTextField: AnimatedPHTextField!
    @IBOutlet var emailTextField: AnimatedPHTextField!

    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var addMoreReferenceButton: UIButton!
    @IBOutlet var referenceLabel: UILabel!
    @IBOutlet var addMoreButtonTopSpace: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(empRef: EmployeeReferenceModel?, tag: Int) {
        referenceLabel.text = "Reference \(tag + 1)"
        deleteButton.tag = tag
        addMoreReferenceButton.tag = tag
        nameTextField.tag = tag
        mobileNoTextField.tag = tag
        emailTextField.tag = tag
        mobileNoTextField.addRightToolBarButton(title: "Done")

        nameTextField.text = empRef?.referenceName
        mobileNoTextField.text = empRef?.mobileNumber
        emailTextField.text = empRef?.email
    }
}
