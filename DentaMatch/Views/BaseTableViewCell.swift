import Foundation
import UIKit

protocol BaseTableViewCell {

    static func cellIdentifier() -> String
    func configure(for object: Any?)
}

extension BaseTableViewCell where Self: UITableViewCell {

    static func cellIdentifier() -> String {
        return String(describing: self)
    }

    func configure(for object: Any?) {

    }
}

