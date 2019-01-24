//
//  AutoCompleteTable.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 16/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol AutoCompleteSelectedDelegate {
    @objc optional func didSelect(schoolCategoryId: String, university: University)
}

class AutoCompleteTable: UIView, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var noResultsLabel: UILabel!
    @IBOutlet var autoCompleteTableView: UITableView!
    var universities = [University]()
    var schoolCategoryId = ""

    weak var delegate: AutoCompleteSelectedDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        autoCompleteTableView.dataSource = self
        autoCompleteTableView.delegate = self
        autoCompleteTableView.estimatedRowHeight = 50.0
        autoCompleteTableView.rowHeight = UITableView.automaticDimension
        autoCompleteTableView.register(UINib(nibName: "AutoCompleteTableViewCell", bundle: nil), forCellReuseIdentifier: "AutoCompleteTableViewCell")
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    func updateData(schoolCategoryId: String, universities: [University]) {
        self.universities = universities
        self.schoolCategoryId = schoolCategoryId
        autoCompleteTableView.reloadData()
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        noResultsLabel.isHidden = universities.count == 0 ? false : true
        return universities.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteTableViewCell") as! AutoCompleteTableViewCell
        let university = universities[indexPath.row]
        cell.universityNameLabel.text = university.universityName
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let university = universities[indexPath.row]
            delegate.didSelect!(schoolCategoryId: schoolCategoryId, university: university)
        }
    }
}
