import Foundation
import UIKit

protocol BaseViewInput: class {
    
    func viewController() -> UIViewController
}

extension BaseViewInput where Self: UIViewController {
    
    func viewController() -> UIViewController {
        return self
    }
}

