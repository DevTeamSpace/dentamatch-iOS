import Foundation
import UIKit
import AlamofireImage

extension UIButton {
    
    func setImage(for state: UIControl.State, url: URL, placeholder: UIImage? = nil) {
        af_cancelImageRequest(for: state)
        af_setImage(for: state, url: url, placeholderImage: placeholder, filter: AspectScaledToFillSizeFilter(size: self.bounds.size))
    }
}
