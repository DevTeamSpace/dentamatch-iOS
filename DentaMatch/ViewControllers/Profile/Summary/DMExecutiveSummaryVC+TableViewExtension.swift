//
//  DMExecutiveSummaryVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMExecutiveSummaryVC : UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let executiveSummaryOption = ExecutiveSummary(rawValue: indexPath.section)!
        
        switch executiveSummaryOption {
        case .profileHeader:
            return 213
        case .aboutMe:
            return 256
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let executiveSummaryOption = ExecutiveSummary(rawValue: indexPath.section)!
        
        switch executiveSummaryOption {
            
        case .profileHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.nameLabel.text = "Executive Summary"
            cell.jobTitleLabel.text = "Describe about your work and things you are passionate about."
            if let imageURL = URL(string: UserManager.shared().activeUser.profileImageURL!) {
                cell.photoButton.sd_setImage(with: imageURL, for: .normal, placeholderImage: kPlaceHolderImage)
            }
            cell.photoButton.progressBar.setProgress(profileProgress, animated: true)
            return cell
            
        case .aboutMe:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutMeCell") as! AboutMeCell
            cell.aboutMeTextView.delegate = self
            cell.aboutMeTextView.inputAccessoryView = self.addToolBarOnTextView()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: - TextView Delegates
    
    func textViewDidChange(_ textView: UITextView) {
        if let cell = self.executiveSummaryTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AboutMeCell {
            aboutMe = textView.text
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //        if(text == "\n") {
        //            textView.resignFirstResponder()
        //            return false
        //        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.executiveSummaryTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0)
        DispatchQueue.main.async {
            self.executiveSummaryTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .bottom, animated: true)
        }
        
        if let cell = self.executiveSummaryTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AboutMeCell {
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.executiveSummaryTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
        
        return true
    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if let cell = self.executiveSummaryTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AboutMeCell {
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }
}
