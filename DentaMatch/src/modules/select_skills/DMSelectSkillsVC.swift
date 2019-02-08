//
//  DMSelectSkillsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMSelectSkillsVC: DMBaseVC {
    enum SubSkillOption: Int {
        case subSkill
        case other
    }

    @IBOutlet var subSkillTableView: UITableView!
    
    var viewOutput: DMSelectSkillsViewOutput?

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewOutput?.didLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewOutput?.willAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func setup() {
        view.backgroundColor = UIColor.color(withHexCode: "0470C0")
        subSkillTableView.backgroundColor = UIColor.color(withHexCode: "0470C0")
        subSkillTableView.register(UINib(nibName: "SubSkillCell", bundle: nil), forCellReuseIdentifier: "SubSkillCell")
        subSkillTableView.register(UINib(nibName: "OtherSubSkillTableCell", bundle: nil), forCellReuseIdentifier: "OtherSubSkillTableCell")
        subSkillTableView.rowHeight = UITableView.automaticDimension
        subSkillTableView.estimatedRowHeight = 50.0
    }
}

extension DMSelectSkillsVC: DMSelectSkillsViewInput {

    func reloadData() {
        subSkillTableView.reloadData()
    }
}

extension DMSelectSkillsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        if let _ = viewOutput?.skill {
            return 2
        }
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subSkillOption = SubSkillOption(rawValue: section)!
        switch subSkillOption {
        case .subSkill:
            return viewOutput?.subSkillWithoutOther.count ?? 0
        case .other:
            return 1
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSkillOption = SubSkillOption(rawValue: indexPath.section)!

        switch subSkillOption {
        case .subSkill:
            return UITableView.automaticDimension
        case .other:
            var otherHeight = 0
            if let otherSkill = viewOutput?.otherSkill {
                otherHeight = otherSkill.isSelected ? 120 : 50
            }
            return CGFloat(otherHeight)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewOutput = viewOutput else { return UITableViewCell() }
        let subSkillOption = SubSkillOption(rawValue: indexPath.section)!

        switch subSkillOption {
        case .subSkill:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubSkillCell") as! SubSkillCell
            cell.subSkillLabel.text = viewOutput.subSkillWithoutOther[indexPath.row].subSkillName
            if viewOutput.subSkills[indexPath.row].isSelected {
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
            } else {
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
            }
            return cell
        case .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherSubSkillTableCell") as! OtherSubSkillTableCell
            cell.otherTextView.text = viewOutput.otherSkill?.otherText
            if let _ = viewOutput.otherSkill {
                if viewOutput.otherSkill?.isSelected == true {
                    cell.tickButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                    cell.tickButton.setTitleColor(UIColor.white, for: .normal)
                } else {
                    cell.tickButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                    cell.tickButton.setTitleColor(UIColor.white, for: .normal)
                }
            }
            cell.otherTextView.delegate = self
            return cell
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        let subSkillOption = SubSkillOption(rawValue: indexPath.section)!

        switch subSkillOption {
        case .subSkill:
            let isSelected = viewOutput?.subSkills[indexPath.row].isSelected == true
            
            viewOutput?.subSkills[indexPath.row].isSelected = !isSelected
            subSkillTableView.reloadRows(at: [indexPath], with: .automatic)
        case .other:
            if let _ = viewOutput?.otherSkill {
                let isSelected = viewOutput?.otherSkill?.isSelected == true
                let isOpen = viewOutput?.otherSkill?.isOpenForOther == true
                viewOutput?.otherSkill?.isSelected = !isSelected
                viewOutput?.otherSkill?.isOpenForOther = !isOpen
                subSkillTableView.reloadRows(at: [indexPath], with: .automatic)
                DispatchQueue.main.async {
                    self.subSkillTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
}

extension DMSelectSkillsVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_: UITextView) -> Bool {
        subSkillTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        DispatchQueue.main.async {
            self.subSkillTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .bottom, animated: true)
        }
        return true
    }

    func textViewShouldEndEditing(_: UITextView) -> Bool {
        subSkillTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        viewOutput?.otherText = textView.text.trim()
        viewOutput?.otherSkill?.otherText = textView.text.trim()
    }
}
