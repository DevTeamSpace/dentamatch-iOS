import Foundation
import UIKit

class RootScreenViewController: DMBaseVC {
    
    var viewOutput: RootScreenViewOutput?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewOutput?.didAppear()
    }
}

extension RootScreenViewController: RootScreenViewInput {

}

extension RootScreenViewController {
    
}
