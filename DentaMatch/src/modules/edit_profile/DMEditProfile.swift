import Foundation

protocol DMEditProfileModuleInput: BaseModuleInput {
    
}

protocol DMEditProfileModuleOutput: BaseModuleOutput {
    
    func showSettings()
    func showNotifications()
    func showEditProfile(jobTitles: [JobTitle]?, selectedJob: JobTitle?)
    func showEditWorkExperience(jobTitles: [JobTitle]?, isEditMode: Bool)
    func showEditStudy(selectedSchoolCategories: [SelectedSchool]?)
    func showEditSkills(skills: [Skill]?)
    func showEditAffiliations(selectedAffiliations: [Affiliation]?, isEditMode: Bool)
    func showEditCertificate(certificate: Certification?, isEditMode: Bool)
}

protocol DMEditProfileViewInput: BaseViewInput {
    var viewOutput: DMEditProfileViewOutput? { get set }
    
    func reloadData()
}

protocol DMEditProfileViewOutput: BaseViewOutput {
    var isJobSeekerVerified: String { get }
    var isProfileCompleted: String { get }
    
    var license: License? { get }
    var affiliations: [Affiliation] { get }
    var skills: [Skill] { get }
    var schoolCategories: [SelectedSchool] { get }
    var certifications: [Certification] { get }
    var experiences: [ExperienceModel] { get }
    var dentalStateBoardURL: String { get }
    var jobTitles: [JobTitle] { get }
    var currentJobTitle: JobTitle? { get }
    
    func getUserProfile()
    func getUserProfile(checkForCompletion: Bool)
    func updateProfileScreen(dict: [AnyHashable: Any]?)
    
    func openEditPublicProfileScreen()
    func openSettings()
    func openNotifications()
    func openAffiliationsScreen()
    func openSchoolsScreen()
    func openSkillsScreen()
    func openWorkExperienceScreen()
    func openCertificateScreen(index: Int)
}

protocol DMEditProfilePresenterProtocol: DMEditProfileModuleInput, DMEditProfileViewOutput {
    
}
