import Foundation
import UIKit
import Swinject

protocol ProfileFlowCoordinatorProtocol: BaseFlowProtocol {
    
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
        guard let vc = DMEditProfileInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: vc)
        navigationController = navController
        return navController
    }
}

extension ProfileFlowCoordinator: DMEditProfileModuleOutput {
    
    func showSettings() {
        guard let vc = DMSettingsInitializer.initialize(moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showNotifications() {
        guard let vc = DMNotificationInitializer.initialize(moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEditProfile(jobTitles: [JobTitle]?, selectedJob: JobTitle?) {
        guard let vc = DMPublicProfileInitializer.initialize(jobTitles: jobTitles, selectedJob: selectedJob, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func showEditWorkExperience(jobTitles: [JobTitle]?, isEditMode: Bool) {
        guard let vc = DMWorkExperienceInitializer.initialize(jobTitles: jobTitles, isEditMode: isEditMode, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEditStudy(selectedSchoolCategories: [SelectedSchool]?) {
        guard let vc = DMEditStudyInitializer.initialize(selectedSchoolCategories: selectedSchoolCategories, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEditSkills(skills: [Skill]?) {
        guard let skillsVC = DMEditSkillsInitializer.initialize(skills: skills, moduleOutput: self) as? DMEditSkillsVC,
            let selectSkillsVC = DMSelectSkillsInitializer.initialize(moduleOutput: self) else { return }

        let sideMenu = SSASideMenu(contentViewController: skillsVC, rightMenuViewController: selectSkillsVC)
        sideMenu.panGestureEnabled = false
        sideMenu.delegate = skillsVC
        sideMenu.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(sideMenu, animated: true)
    }
    
    func showEditAffiliations(selectedAffiliations: [Affiliation]?, isEditMode: Bool) {
        guard let vc = DMAffiliationsInitializer.initialize(selectedAffiliations: selectedAffiliations, isEditMode: isEditMode, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEditCertificate(certificate: Certification?, isEditMode: Bool) {
        guard let vc = DMEditCertificateInitializer.initialize(certificate: certificate, isEditMode: isEditMode, moduleOutput: self) else { return }
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
        guard let vc = DMChangePasswordInitializer.initialize(moduleOutput: self) else { return }
        navigationController?.pushViewController(vc, animated: true)
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
    
    func showJobDetails(job: Job?) {
        guard let vc = DMJobDetailInitializer.initialize(job: job, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileFlowCoordinator: DMPublicProfileModuleOutput {
    
    func showStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?) {
        guard let vc = SearchStateInitializer.initialize(preselectedState: preselectedState, delegate: delegate, moduleOutput: self) else { return }
        navigationController?.pushViewController(vc, animated: true)
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
