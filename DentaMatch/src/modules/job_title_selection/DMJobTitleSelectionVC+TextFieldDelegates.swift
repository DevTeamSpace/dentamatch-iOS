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
        guard text.count > 0 else {
            return true
        }
        if textView.text.count >= Constants.Limit.aboutMeLimit && range.length == 0 {
            return false
        }
        if textView.text.count + text.count > Constants.Limit.aboutMeLimit && range.length == 0 {
            let remainingTextCount = Constants.Limit.aboutMeLimit - textView.text.count
            textView.text = textView.text + text.stringFrom(0, to: remainingTextCount)
            return false
        }
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }

        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        jobTitleSelectionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        DispatchQueue.main.async { [weak self] in
            self?.jobTitleSelectionTableView.scrollToRow(at: IndexPath(row: 3, section: 0), at: .bottom, animated: true)
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
        jobTitleSelectionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
