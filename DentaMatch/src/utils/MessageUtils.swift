import Foundation
import UIKit

func showMessage(title: String, message: String, viewController: UIViewController?, completion: @escaping() -> Void = {}) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
        completion()
    })
    
    viewController?.present(alert, animated: true)
}

