//
//  ReferenceTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 03/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ReferenceTableCell: UITableViewCell {
    @IBOutlet weak var nameTextField: AnimatedPHTextField!
    @IBOutlet weak var mobileNoTextField: AnimatedPHTextField!
    @IBOutlet weak var emailTextField: AnimatedPHTextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addMoreReferenceButton: UIButton!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var addMoreButtonTopSpace: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(empRef: EmployeeReferenceModel? , tag:Int) {
    
        self.deleteButton.tag = tag
        self.addMoreReferenceButton.tag = tag
        self.nameTextField.tag = tag
        self.mobileNoTextField.tag = tag
        self.emailTextField.tag = tag
        self.mobileNoTextField.addRightToolBarButton(title: "Done")
        
        self.nameTextField.text = empRef?.referenceName
        self.mobileNoTextField.text = empRef?.mobileNumber
        self.emailTextField.text = empRef?.email




    }
    
}
