import Foundation

protocol DMPublicProfileModuleInput: BaseModuleInput {
    
}

protocol DMPublicProfileModuleOutput: BaseModuleOutput {
    
    func showStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?)
}

protocol DMPublicProfileViewInput: BaseViewInput {
    var viewOutput: DMPublicProfileViewOutput? { get set }
    
    func configureLocationPicker(locations: [PreferredLocation])
    func reloadData()
}

protocol DMPublicProfileViewOutput: BaseViewOutput {
    var jobTitles: [JobTitle] { get }
    var selectedJob: JobTitle? { get }
    var licenseString: String? { get }
    var stateString: String? { get set }
    var editProfileParams: [String: String] { get set }
    var preferredLocations: [PreferredLocation] { get }
    var selectedLocation: PreferredLocation? { get set }
    var profileImage: UIImage? { get }
    
    func didLoad()
    func validateFields() -> Bool
    func updatePublicProfile()
    func uploadProfileImage(_ image: UIImage)
    func openStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?)
    func textFieldDidEndEditins(type: ProfileOptions, text: String)
    func onPickerDoneButtonTap(job: JobTitle?)
}

protocol DMPublicProfilePresenterProtocol: DMPublicProfileModuleInput, DMPublicProfileViewOutput {
    
}
