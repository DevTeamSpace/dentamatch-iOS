import Foundation
import SwiftyJSON

class DMEditProfilePresenter: DMEditProfilePresenterProtocol {
    
    unowned let viewInput: DMEditProfileViewInput
    unowned let moduleOutput: DMEditProfileModuleOutput
    
    init(viewInput: DMEditProfileViewInput, moduleOutput: DMEditProfileModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var isJobSeekerVerified = ""
    var isProfileCompleted = ""
    var license: License?
    var affiliations = [Affiliation]()
    var skills = [Skill]()
    var schoolCategories = [SelectedSchool]()
    var certifications = [Certification]()
    var experiences = [ExperienceModel]()
    var dentalStateBoardURL = ""
    var jobTitles = [JobTitle]()
    var currentJobTitle: JobTitle?
}

extension DMEditProfilePresenter: DMEditProfileModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMEditProfilePresenter: DMEditProfileViewOutput {
    
    func getUserProfile() {
        getUserProfile(checkForCompletion: false)
    }
    
    func getUserProfile(checkForCompletion: Bool) {
        
        if checkForCompletion {
            viewInput.showLoading()
        }
        
        APIManager.apiGet(serviceName: Constants.API.userProfile, parameters: [:]) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if checkForCompletion {
                self?.handleUserResponse(user: response[Constants.ServerKey.result][Constants.ServerKey.user])
            } else {
                self?.handleProfileResponse(response: response)
            }
            
            self?.viewInput.reloadData()
        }
    }
    
    func openEditPublicProfileScreen() {
        moduleOutput.showEditProfile(jobTitles: jobTitles, selectedJob: currentJobTitle)
    }
    
    func openSettings() {
        moduleOutput.showSettings()
    }
    
    func openNotifications() {
        moduleOutput.showNotifications()
    }
    
    func openAffiliationsScreen() {
        moduleOutput.showEditAffiliations(selectedAffiliations: affiliations, isEditMode: true)
    }
    
    func openSchoolsScreen() {
        moduleOutput.showEditStudy(selectedSchoolCategories: schoolCategories)
    }
    
    func openSkillsScreen() {
        moduleOutput.showEditSkills(skills: skills)
    }
    
    func openWorkExperienceScreen() {
        moduleOutput.showEditWorkExperience(jobTitles: jobTitles, isEditMode: true)
    }
    
    func openCertificateScreen(index: Int) {
        moduleOutput.showEditCertificate(certificate: certifications[index], isEditMode: true)
    }
    
    func updateProfileScreen(dict: [AnyHashable : Any]?) {
        
        if let license = dict?["license"] {
            self.license = license as? License
        }
        
        // For Work Experience
        if let experiences = dict?["workExperiences"]  as? [ExperienceModel] {
            self.experiences = experiences
        }
        
        // Upload for affiliation
        if let affiliation = dict?["affiliations"] as? [Affiliation]{
            affiliations = affiliation
        }
        
        // For Schools
        if let schools = dict?["schools"] as? [SelectedSchool]{
            schoolCategories = schools
        }
        
        // For Skills
        if let skills = dict?["skills"] as? [Skill]{
            self.skills = skills
        }
        
        // Update for certificate
        if let certification = dict?["certification"], let certificateObj = certification as? Certification {
            for certificate in certifications {
                if certificateObj.certificationId == certificate.certificationId {
                    certificate.certificateImageURL = certificateObj.certificateImageURL
                }
            }
        }
        
        if let dentalStateBoardURL = dict?["dentalStateBoardImageURL"], let url = dentalStateBoardURL as? String {
            self.dentalStateBoardURL = url
        }
        
        viewInput.reloadData()
        getUserProfile(checkForCompletion: true)
    }
}

extension DMEditProfilePresenter {
    
    private func handleUserResponse(user: JSON?) {
        if let user = user {
            UserManager.shared().activeUser.firstName = user[Constants.ServerKey.firstName].stringValue
            UserManager.shared().activeUser.lastName = user[Constants.ServerKey.lastName].stringValue
            UserManager.shared().activeUser.jobTitle = user[Constants.ServerKey.jobtitleName].stringValue
            UserManager.shared().activeUser.jobTitleId = user[Constants.ServerKey.jobTitileId].stringValue
            UserManager.shared().activeUser.profileImageURL = user[Constants.ServerKey.profilePic].stringValue
            UserManager.shared().activeUser.preferredJobLocation = user[Constants.ServerKey.preferredLocationName].stringValue
            UserManager.shared().activeUser.preferredLocationId = user[Constants.ServerKey.preferredJobLocationId].stringValue
            UserManager.shared().activeUser.state = user[Constants.ServerKey.state].stringValue
            
            currentJobTitle = jobTitles.filter({ $0.jobId == user[Constants.ServerKey.jobTitileId].intValue }).first
            
            UserManager.shared().activeUser.aboutMe = user[Constants.ServerKey.aboutMe].stringValue
            UserManager.shared().activeUser.licenseNumber = user[Constants.ServerKey.licenseNumber].stringValue
            isJobSeekerVerified = user["isJobSeekerVerified"].stringValue
            isProfileCompleted = user["isCompleted"].stringValue
            
            UserManager.shared().saveActiveUser()
        }
    }
    
    private func handleProfileResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                handleJobListResponse(jobLists: response[Constants.ServerKey.result][Constants.ServerKey.joblists].arrayValue)
                handleUserResponse(user: response[Constants.ServerKey.result][Constants.ServerKey.user])
                handleDentalStateboardResponse(dentalStateBoard: response[Constants.ServerKey.result][Constants.ServerKey.dentalStateBoard])
                handleLicenseResponse(license: response[Constants.ServerKey.result][Constants.ServerKey.license])
                handleCertificationResponse(certifications: response[Constants.ServerKey.result][Constants.ServerKey.certifications].arrayValue)
                handleAffiliationResponse(affiliations: response[Constants.ServerKey.result][Constants.ServerKey.affiliations].arrayValue)
                handleSchoolListResponse(schoolsCategories: response[Constants.ServerKey.result][Constants.ServerKey.school].arrayValue)
                handleSkillsResponse(skills: response[Constants.ServerKey.result][Constants.ServerKey.skills].arrayValue)
                handleWorkExperienceResponse(workExperienceArray: response[Constants.ServerKey.result][Constants.ServerKey.workExperience][Constants.ServerKey.list].arrayValue)
            } else {
                // handle error
            }
        }
    }
    
    private func handleDentalStateboardResponse(dentalStateBoard: JSON?) {
        if let dentalStateBoard = dentalStateBoard {
            dentalStateBoardURL = dentalStateBoard[Constants.ServerKey.imageUrl].stringValue
        }
    }
    
    private func handleJobListResponse(jobLists: [JSON]?) {
        jobTitles.removeAll()
        if let jobLists = jobLists {
            for jobList in jobLists {
                let jobTitle = JobTitle(job: jobList)
                
                jobTitles.append(jobTitle)
            }
        }
    }
    
    private func handleLicenseResponse(license: JSON?) {
        if !(license?[Constants.ServerKey.licenseNumber].stringValue.isEmptyField)! {
            if let license = license {
                self.license = License(license: license)
            }
        }
    }
    
    private func handleSchoolListResponse(schoolsCategories: [JSON]?) {
        schoolCategories.removeAll()
        if let schoolsCategories = schoolsCategories {
            for schoolCategory in schoolsCategories {
                let school = SelectedSchool(school: schoolCategory)
                schoolCategories.append(school)
            }
        }
    }
    
    private func handleCertificationResponse(certifications: [JSON]?) {
        self.certifications = [Certification]()
        if let certifications = certifications {
            for certification in certifications {
                let certification = Certification(certification: certification)
                self.certifications.append(certification)
            }
        }
    }
    
    private func handleAffiliationResponse(affiliations: [JSON]?) {
        self.affiliations = [Affiliation]()
        if let affiliations = affiliations {
            for affiliation in affiliations {
                let affiliation = Affiliation(affiliation: affiliation)
                self.affiliations.append(affiliation)
            }
        }
    }
    
    private func handleSkillsResponse(skills: [JSON]?) {
        self.skills.removeAll()
        if let skills = skills {
            for skillObj in skills {
                var subSkills = [SubSkill]()
                let subSkillsArray = skillObj["children"].arrayValue
                
                for subSkillObj in subSkillsArray {
                    let subSkill = SubSkill(subSkill: subSkillObj)
                    subSkills.append(subSkill)
                }
                
                let skill = Skill(skills: skillObj, subSkills: subSkills)
                self.skills.append(skill)
            }
            // otherSkill = skills.filter({$0.isOther == true}).first
            // skills = skills.filter({$0.isOther == false})
        }
    }
    
    private func handleWorkExperienceResponse(workExperienceArray: [JSON]?) {
        experiences.removeAll()
        if let workExperienceArray = workExperienceArray {
            for workExperience in workExperienceArray {
                let workExperience = ExperienceModel(json: workExperience)
                experiences.append(workExperience)
            }
        }
    }
}
