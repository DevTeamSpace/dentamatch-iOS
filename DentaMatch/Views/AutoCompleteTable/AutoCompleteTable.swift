//
//  AutoCompleteTable.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 16/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol AutoCompleteSelectedDelegate {
    @objc optional func didSelect(schoolCategoryId:String,university:University)
}

class AutoCompleteTable: UIView,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var autoCompleteTableView: UITableView!
    var universities = [University]()
    var schoolCategoryId = ""
    
    var delegate:AutoCompleteSelectedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.autoCompleteTableView.dataSource = self
        self.autoCompleteTableView.estimatedRowHeight = 50.0
        self.autoCompleteTableView.rowHeight = UITableViewAutomaticDimension
        self.autoCompleteTableView.register(UINib(nibName: "AutoCompleteTableViewCell", bundle: nil), forCellReuseIdentifier: "AutoCompleteTableViewCell")

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateData(schoolCategoryId:String, universities:[University]) {
        self.universities = universities
        self.schoolCategoryId = schoolCategoryId
        self.autoCompleteTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteTableViewCell") as! AutoCompleteTableViewCell
        let university = universities[indexPath.row]
        cell.universityNameLabel.text = university.universityName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let university = universities[indexPath.row]
            delegate.didSelect!(schoolCategoryId: schoolCategoryId, university: university)
        }
    }
    
    

}
