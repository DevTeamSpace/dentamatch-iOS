//
//  TagCell.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 23/08/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    enum CellType {
        case date
        case seeMore
    }
    @IBOutlet private weak var textLabel: UILabel?
    var type: CellType = .date
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textLabel?.font = UIFont.fontRegular(fontSize: 10)
        self.textLabel?.layer.cornerRadius = 10
        self.textLabel?.layer.masksToBounds = true
        self.textLabel?.layer.borderWidth = 0.5
        self.textLabel?.layer.borderColor = Constants.Color.notificationUnreadTextColor.cgColor
    }
    
    func setTag(with text: String, type: CellType = .date) {
        self.textLabel?.text = text
        self.configureUI(type)
    }
    
    private func configureUI(_ type: CellType){
        self.type = type
        if type == .date {
            self.textLabel?.backgroundColor = Constants.Color.notificationUnreadTextColor
            self.textLabel?.textColor = UIColor.white
        }else{
            self.textLabel?.backgroundColor = UIColor.white
            self.textLabel?.textColor = Constants.Color.notificationUnreadTextColor
        }
    }

}
