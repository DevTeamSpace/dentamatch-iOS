//
//  AnimatedPHToolTipCell.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 26/10/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class AnimatedPHToolTipCell: UITableViewCell {
    @IBOutlet weak var commonTextField: AnimatedPHTextField!
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var toolTipLabel: UILabel?
    var showKeyboard: Bool = true
    
    private var editingHandler: (String?) -> Void = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonTextField.delegate = self
    }
    
    func editAction(_ handler: @escaping (String?) -> Void) {
        editingHandler = handler
    }
}

extension AnimatedPHToolTipCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !showKeyboard { textField.resignFirstResponder() }
        guard let keyword = textField.text else {
            editingHandler(nil)
            return
        }
        editingHandler(keyword.trimText)
    }
}

