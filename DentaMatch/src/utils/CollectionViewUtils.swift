import Foundation
import UIKit

struct CollectionViewCellDescription {
    let cellType: BaseCollectionViewCell.Type
    let height: CGFloat
    let width: CGFloat
    var object: Any?

    init(cellType: BaseCollectionViewCell.Type, width: CGFloat = 0, height: CGFloat = 0, object: Any?) {
        self.cellType = cellType
        self.height = height
        self.width = width
        self.object = object
    }
}

let UICollectionViewAutomaticDimension: CGFloat = -1.0

extension UICollectionView {

    func register<T: BaseCollectionViewCell>(_ classType: T.Type) {
        register(UINib(nibName: classType.cellIdentifier(), bundle: nil),
                 forCellWithReuseIdentifier: classType.cellIdentifier())
    }

    func configureCell(with cellDescription: CollectionViewCellDescription,
                       for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(
            withReuseIdentifier: cellDescription.cellType.cellIdentifier(),
            for: indexPath
        )
        if let baseCell = cell as? BaseCollectionViewCell {
            baseCell.configure(for: cellDescription.object)
        }
        return cell
    }
}

extension UICollectionView {
    public func indexPathForCell(whichContains view: UIView?) -> IndexPath? {
        let convertedOriginPoint = convert(CGPoint.zero, from: view)
        return indexPathForItem(at: convertedOriginPoint)
    }
}
