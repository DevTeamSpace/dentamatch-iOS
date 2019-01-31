import Foundation

class RootScreenPresenter: RootScreenPresenterProtocol {
    
    unowned let viewInput: RootScreenViewInput
    unowned let moduleOutput: RootScreenModuleOutput

    init(viewInput: RootScreenViewInput, moduleOutput: RootScreenModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension RootScreenPresenter: RootScreenModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension RootScreenPresenter: RootScreenViewOutput {

    func didAppear() {
        
        if UserDefaultsManager.sharedInstance.isProfileCompleted {
            moduleOutput.showDashboard()
            return
        }
        
        if !UserDefaultsManager.sharedInstance.isProfileSkipped {
            if UserDefaultsManager.sharedInstance.isLoggedIn {
                if !UserManager.shared().activeUser.jobTitle!.isEmptyField {
                    moduleOutput.showSuccessPendingScreen()
                } else {
                    moduleOutput.showProfile()
                }
            } else {
                if UserDefaultsManager.sharedInstance.isOnBoardingDone {
                    moduleOutput.showRegistration()
                } else {
                    moduleOutput.showOnboarding()
                }
            }
        } else {
            moduleOutput.showDashboard()
        }
    }
}

extension RootScreenPresenter {
    
}

