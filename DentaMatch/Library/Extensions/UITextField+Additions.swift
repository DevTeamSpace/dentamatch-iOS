//
//  UITextField+Additions.swift
//
//  Created by Geetika Gupta on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITextField Extension

extension UITextField {
    /**
     Override method of awake from nib to change font size as per aspect ratio.
     */
    open override func awakeFromNib() {
        super.awakeFromNib()
//        updateCharacterSpace()
    }


    func changePlaceholderColor(_ color: UIColor) {
        if let string = placeholder {
            attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }

    func isTextFieldEmpty() -> Bool {
        if let str = self.text /* self.textByTrimmingWhiteSpacesAndNewline() */ {
            return str.length == 0
        }
        return true
    }

    func textByTrimmingWhiteSpacesAndNewline() -> String {
        trimWhiteSpacesAndNewline()
        guard text != nil else {
            return ""
        }
        return text!
    }

    func trimWhiteSpacesAndNewline() {
        let whitespaceAndNewline: CharacterSet = CharacterSet.whitespacesAndNewlines
        let trimmedString: String? = text?.trimmingCharacters(in: whitespaceAndNewline)
        text = trimmedString
    }

    func trimText() -> String {
        let whitespaceAndNewline: CharacterSet = CharacterSet.whitespacesAndNewlines
        let trimmedString: String? = text?.trimmingCharacters(in: whitespaceAndNewline)
        return trimmedString ?? ""
    }

    // check if text field is empty
    func isEmpty() -> Bool {
        guard let string = self.text else {
            return true
        }
        let whitespaceSet = CharacterSet.whitespaces
        return string.trimmingCharacters(in: whitespaceSet).isEmpty
    }

    // MARK: Control Actions

    @IBAction func toggleSecureText() {
        isSecureTextEntry = !isSecureTextEntry
    }
}
