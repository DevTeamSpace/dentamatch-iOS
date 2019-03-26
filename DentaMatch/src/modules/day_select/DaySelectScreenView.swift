import Foundation
import UIKit

class DaySelectScreenView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var acceptButton: UIButton! {
        didSet {
            acceptButton.layer.cornerRadius = acceptButton.frame.height / 2
        }
    }
}
