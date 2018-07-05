//
//  AnimatedPHTextField.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 01/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AnimatedPHTextField: FloatLabelTextField {
    private var leftTextFieldView: UIView?
    var type = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        autocorrectionType = .no
        autocapitalizationType = .sentences
        textColor = Constants.Color.textFieldTextColor
        titleYPadding = 5.0
        titleFont = UIFont.fontRegular(fontSize: 12.0)!
        titleActiveTextColour = Constants.Color.textFieldPlaceHolderColor
        titleTextColour = Constants.Color.textFieldPlaceHolderColor
        leftTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
        leftView = leftTextFieldView
        leftViewMode = .always
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.0
        layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
    }

    override func canPerformAction(_ action: Selector, withSender _: Any?) -> Bool {
        if type != 0 || action == #selector(delete(_:)) {
            return false
        }
        return true
    }

}
