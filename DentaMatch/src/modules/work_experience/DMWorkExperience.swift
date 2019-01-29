import Foundation

protocol DMWorkExperienceModuleOutput: BaseModuleOutput {

    func showStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?)
}
