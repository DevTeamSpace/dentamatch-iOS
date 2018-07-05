//
//  DMJobTitleSelectionVC+TextFieldDelegates.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMJobTitleSelectionVC: UITextViewDelegate {

    // MARK: - TextView Delegates

    func textViewDidChange(_ textView: UITextView) {
        aboutMe = textView.text
        if let cell = self.jobTitleSelectionTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? AboutMeJobSelectionCell {
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
            changeUIOFCreateProfileButton(isCreateProfileButtonEnable())
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.characters.count > 0 else {
            return true
        }
        if textView.text.characters.count >= Constants.Limit.aboutMeLimit && range.length == 0 {
            return false
        }
        if textView.text.characters.count + text.characters.count > Constants.Limit.aboutMeLimit && range.length == 0 {
            let remainingTextCount = Constants.Limit.aboutMeLimit - textView.text.characters.count
            textView.text = textView.text + text.stringFrom(0, to: remainingTextCount)
            return false
        }

        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        jobTitleSelectionTableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0)
        DispatchQueue.main.async {
            self.jobTitleSelectionTableView.scrollToRow(at: IndexPath(row: 3, section: 0), at: .bottom, animated: true)
        }

        if let cell = self.jobTitleSelectionTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? AboutMeJobSelectionCell {
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }

    func textViewShouldEndEditing(_: UITextView) -> Bool {
        jobTitleSelectionTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let cell = self.jobTitleSelectionTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? AboutMeJobSelectionCell {
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }
}
