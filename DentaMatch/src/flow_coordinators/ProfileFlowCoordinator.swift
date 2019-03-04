import Foundation
import UIKit
import Swinject

protocol ProfileFlowCoordinatorProtocol: BaseFlowProtocol {
    func presentChat(chatObject: ChatObject)
}

protocol ProfileFlowCoordinatorDelegate: class {
    
    func logoutFromSettings()
}

class ProfileFlowCoordinator: BaseFlowCoordinator, ProfileFlowCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    unowned let delegate: ProfileFlowCoordinatorDelegate
    
    init(delegate: ProfileFlowCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func launchViewController() -> UIViewController? {
        guard let moduleInput = DMEditProfileInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: moduleInput.viewController())
        navigationController = navController
        return navController
    }
}

extension ProfileFlowCoordinator: DMEditProfileModuleOutput {
    
    func showSettings() {
        guard let moduleInput = DMSettingsInitializer.initialize(moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showNotifications() {
        guard let moduleInput = DMNotificationInitializer.initialize(moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEditProfile(jobTitles: [JobTitle]?, selectedJob: JobTitle?) {
        guard let moduleInput = DMPublicProfileInitializer.initialize(jobTitles: jobTitles, selectedJob: selectedJob, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func showEditWorkExperience(jobTitles: [JobTitle]?, isEditMode: Bool) {
        guard let moduleInput = DMWorkExperienceInitializer.initialize(jobTitles: jobTitles, isEditMode: isEditMode, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEditStudy(selectedSchoolCategories: [SelectedSchool]?) {
        guard let moduleInput = DMEditStudyInitializer.initialize(selectedSchoolCategories: selectedSchoolCategories, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEditSkills(skills: [Skill]?) {
        guard let skillsModuleInput = DMEditSkillsInitializer.initialize(skills: skills, moduleOutput: self),
            let selectSkillsModuleInput = DMSelectSkillsInitializer.initialize(moduleOutput: self) else { return }

        let sideMenu = SSASideMenu(contentViewController: skillsModuleInput.viewController(), rightMenuViewController: selectSkillsModuleInput.viewController())
        sideMenu.panGestureEnabled = false
        sideMenu.delegate = skillsModuleInput.viewController() as? DMEditSkillsVC
        sideMenu.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(sideMenu, animated: true)
    }
    
    func showEditAffiliations(selectedAffiliations: [Affiliation]?, isEditMode: Bool) {
        guard let moduleInput = DMAffiliationsInitializer.initialize(selectedAffiliations: selectedAffiliations, isEditMode: isEditMode, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEditCertificate(certificate: Certification?, isEditMode: Bool) {
        guard let moduleInput = DMEditCertificateInitializer.initialize(certificate: certificate, isEditMode: isEditMode, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileFlowCoordinator: DMSettingsModuleOutput {
    
    func showLoginScreen() {
        
        delegate.logoutFromSettings()
    }
    
    func showTermsAndConditions(isPrivacyPolicy: Bool) {
        guard let moduleInput = DMTermsAndConditionsInitializer.initialize(isPrivacyPolicy: isPrivacyPolicy, moduleOutput: self) else { return }
        navigationController?.pushViewController(moduleInput.viewController(), animated: true)
    }
    
    func showResetPassword() {
        guard let moduleInput = DMChangePasswordInitializer.initialize(moduleOutput: self) else { return }
        navigationController?.pushViewController(moduleInput.viewController(), animated: true)
    }
    
    func showRegisterMaps(delegate: LocationAddressDelegate?) {
        guard let moduleInput = DMRegisterMapsInitializer.initialize(fromSettings: true, delegate: delegate, moduleOutput: self) else { return }
        navigationController?.pushViewController(moduleInput.viewController(), animated: true)
    }
}

extension ProfileFlowCoordinator: DMTermsAndConditionsModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMChangePasswordModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMNotificationsModuleOutput {
    
    func showJobDetails(job: Job?, recruiterId: String?) {
        guard let moduleInput = DMJobDetailInitializer.initialize(job: job, recruiterId: recruiterId, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentChat(chatObject: ChatObject) {
        guard let moduleInput = DMChatInitializer.initialize(chatObject: chatObject, moduleOutput: self) else { return }
        
        let navCon = UINavigationController(rootViewController: moduleInput.viewController())
        navigationController?.present(navCon, animated: true)
    }
}

extension ProfileFlowCoordinator: DMChatModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMPublicProfileModuleOutput {
    
    func showStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?) {
        guard let moduleInput = SearchStateInitializer.initialize(preselectedState: preselectedState, delegate: delegate, moduleOutput: self) else { return }
        navigationController?.pushViewController(moduleInput.viewController(), animated: true)
    }
}

extension ProfileFlowCoordinator: SearchStateModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMWorkExperienceModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMEditStudyModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMEditSkillsModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMSelectSkillsModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMAffiliationsModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMEditCertificateModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMJobDetailModuleOutput {
    
    
}

extension ProfileFlowCoordinator: DMRegisterMapsModuleOutput {
    
    
}
