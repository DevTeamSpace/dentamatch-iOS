import Foundation

protocol DMJobSearchModuleOutput: BaseModuleOutput {
    
    func showJobTitle(selectedTitles: [JobTitle]?, isLocation: Bool, locations: [PreferredLocation]?, delegate: DMJobTitleVCDelegate)
}
