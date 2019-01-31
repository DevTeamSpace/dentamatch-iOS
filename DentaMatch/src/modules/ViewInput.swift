import Foundation
import UIKit

protocol BaseViewInput: class {
    
    func popViewController()
    func viewController() -> UIViewController
    func showLoading()
    func hideLoading()
    func show(toastMessage: String)
    func showAlertMessage(title: String, body: String)
    func showAlertMessage(title: String, body: String, completion: @escaping() -> Void)
}

extension BaseViewInput where Self: UIViewController {
    
    func viewController() -> UIViewController {
        return self
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlertMessage(title: String, body: String) {
        showMessage(title: title, message: body, viewController: self)
    }
    
    func showAlertMessage(title: String, body: String, completion: @escaping() -> Void) {
        showMessage(title: title, message: body, viewController: self, completion: completion)
    }
}

extension BaseViewInput where Self: DMBaseVC {
    
    func showLoading() {
        showLoader()
    }
    
    func hideLoading() {
        hideLoader()
    }
    
    func show(toastMessage: String) {
        makeToast(toastString: toastMessage)
    }
}

