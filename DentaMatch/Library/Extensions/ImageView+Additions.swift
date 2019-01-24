import Foundation
import UIKit
import AlamofireImage

extension UIImageView {
    
    func setImage(withURL url: URL, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        af_cancelImageRequest()
        af_setImage(withURL: url, placeholderImage: placeholder, imageTransition: .crossDissolve(0.2)) { (response) in
            completion?(response.value)
        }
    }
}
