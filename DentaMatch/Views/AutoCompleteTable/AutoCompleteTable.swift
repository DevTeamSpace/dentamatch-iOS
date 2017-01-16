//
//  AutoCompleteTable.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 16/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AutoCompleteTable: UIView,UITableViewDataSource {

    @IBOutlet weak var autoCompleteTableView: UITableView!
    var universities = [University]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.autoCompleteTableView.dataSource = self
        self.autoCompleteTableView.register(UINib(nibName: "AutoCompleteTableViewCell", bundle: nil), forCellReuseIdentifier: "AutoCompleteTableViewCell")

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateData(universities:[University]) {
        self.universities = universities
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteTableViewCell") as! AutoCompleteTableViewCell
        let university = universities[indexPath.row]
        cell.universityNameLabel.text = university.universityName
        return cell
    }
    
    

}
