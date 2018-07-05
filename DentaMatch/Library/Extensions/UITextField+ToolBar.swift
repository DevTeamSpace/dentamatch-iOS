//
//  UITextField+ToolBar.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

enum Position: Int {
    case Left = 1
    case Right
}

protocol ToolBarButtonDelegate {
    func toolBarButtonPressed(position: Position)
}

var delegate: ToolBarButtonDelegate?

extension UITextField {
    func addLeftToolBarButton(title: String) {
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        keyboardDoneButtonView.barTintColor = Constants.Color.toolBarColor
        // Setup the buttons to be put in the system.
        let item = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(toolBarButtonPressed))
        item.tag = 1
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.fontRegular(fontSize: 20.0)!], for: UIControlState.normal)

        item.tintColor = UIColor.white
        let toolbarButtons = [item]

        // Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        inputAccessoryView = keyboardDoneButtonView
    }

    func addRightToolBarButton(title: String) {
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        keyboardDoneButtonView.barTintColor = Constants.Color.toolBarColor
        // Setup the buttons to be put in the system.
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)

        let item = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(toolBarButtonPressed))
        item.tag = 2
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.fontRegular(fontSize: 20.0)!], for: UIControlState.normal)

        item.tintColor = UIColor.white

        let toolbarButtons = [flexibleSpace, item]

        // Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        inputAccessoryView = keyboardDoneButtonView
    }

    @objc func toolBarButtonPressed(barButton: UIBarButtonItem) {
        if let delegate = delegate as? ToolBarButtonDelegate {
            if barButton.tag == 1 {
                delegate.toolBarButtonPressed(position: Position.Left)
            } else {
                delegate.toolBarButtonPressed(position: Position.Right)
            }
        }
    }
}
