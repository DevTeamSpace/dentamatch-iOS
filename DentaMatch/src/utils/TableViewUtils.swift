import Foundation
import UIKit

struct TableViewCellDescription {
    let cellType: BaseTableViewCell.Type
    var height: CGFloat
    var object: Any?
    init(cellType: BaseTableViewCell.Type, height: CGFloat = 0, object: Any?) {
        self.cellType = cellType
        self.height = height
        self.object = object
    }
}

extension UITableView {

    func register<T: BaseTableViewCell>(_ classType: T.Type) {
        register(UINib(nibName: classType.cellIdentifier(), bundle: nil),
                 forCellReuseIdentifier: classType.cellIdentifier())
    }

    func configureCell(with cellDescription: TableViewCellDescription, for indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: cellDescription.cellType.cellIdentifier(), for: indexPath)
        if let baseCell = cell as? BaseTableViewCell {
            baseCell.configure(for: cellDescription.object)
        }
        return cell
    }
}
