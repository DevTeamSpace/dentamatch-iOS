import Foundation
import UIKit

class DMBaseNC: UINavigationController {

    private var innerModalPresentationStyle: UIModalPresentationStyle = .fullScreen

    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            innerModalPresentationStyle
        }
        set {
            innerModalPresentationStyle = newValue
        }
    }

}
