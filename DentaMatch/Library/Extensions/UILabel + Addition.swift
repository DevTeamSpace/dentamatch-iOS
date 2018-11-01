//
//  UILabel + Addition.swift
//  Wivi
//
//  Created by Harish on 09/04/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
@IBDesignable
extension UILabel {
    func setLineHeightT(_ lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)

            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineHeight
            style.alignment = textAlignment
            if let font = self.font {
                let attrs = [NSAttributedStringKey.font: font]
                attributeString.addAttributes(attrs, range: NSMakeRange(0, text.count))
            }
            attributeString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                         value: style,
                                         range: NSMakeRange(0, text.count))
            attributedText = attributeString
        }
    }

}
