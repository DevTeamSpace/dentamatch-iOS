import Foundation

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
