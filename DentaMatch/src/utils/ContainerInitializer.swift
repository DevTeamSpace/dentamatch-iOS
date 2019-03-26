import Foundation
import Swinject
import SwinjectStoryboard

var appContainer: Container {
    return AppDelegate.delegate().container
}

func defaultContainer() -> Container {
    
    Container.loggingFunction = nil
    let container = Container()
    
    container.register(AuthorizationFlowCoordinatorProtocol.self) { r, delegate in
        return AuthorizationFlowCoordinator(delegate: delegate)
    }
    
    container.register(RegistrationFlowCoordinatorProtocol.self) { r, delegate in
        return RegistrationFlowCoordinator(delegate: delegate)
    }
    
    container.register(TabBarFlowCoordinatorProtocol.self) { r, delegate in
        return TabBarFlowCoordinator(delegate: delegate)
    }
    
    container.register(JobsFlowCoordinatorProtocol.self) { r, delegate in
        return JobsFlowCoordinator(delegate: delegate)
    }
    
    container.register(TrackFlowCoordinatorProtocol.self) { r, delegate in
        return TrackFlowCoordinator(delegate: delegate)
    }
    
    container.register(CalendarFlowCoordinatorProtocol.self) { r, delegate in
        return CalendarFlowCoordinator(delegate: delegate)
    }
    
    container.register(MessagesFlowCoordinatorProtocol.self) { r, delegate in
        return MessagesFlowCoordinator(delegate: delegate)
    }
    
    container.register(ProfileFlowCoordinatorProtocol.self) { r, delegate in
        return ProfileFlowCoordinator(delegate: delegate)
    }
    
    RootScreenInitializer.register(for: container)
    DMRegistrationContainerInitializer.register(for: container)
    DMRegistrationInitializer.register(for: container)
    DMLoginInitializer.register(for: container)
    DMForgotPasswordInitializer.register(for: container)
    DMTermsAndConditionsInitializer.register(for: container)
    DMRegisterMapsInitializer.register(for: container)
    DMOnboardingInitializer.register(for: container)
    TabBarInitializer.register(for: container)
    DMJobSearchResultInitializer.register(for: container)
    DMJobSearchInitializer.register(for: container)
    DMJobTitleInitializer.register(for: container)
    DMJobDetailInitializer.register(for: container)
    DMTrackInitializer.register(for: container)
    DMCancelJobInitializer.register(for: container)
    DMCalendarInitializer.register(for: container)
    DMCalendarSetAvailabilityInitializer.register(for: container)
    DMMessagesInitializer.register(for: container)
    DMChatInitializer.register(for: container)
    DMNotificationInitializer.register(for: container)
    DMSettingsInitializer.register(for: container)
    DMChangePasswordInitializer.register(for: container)
    SearchStateInitializer.register(for: container)
    DMCommonSuccessFailureInitializer.register(for: container)
    DMEditStudyInitializer.register(for: container)
    DMEditSkillsInitializer.register(for: container)
    DMEditDentalStateInitializer.register(for: container)
    DMEditCertificateInitializer.register(for: container)
    DMPublicProfileInitializer.register(for: container)
    DMEditLicenseInitializer.register(for: container)
    DMEditProfileInitializer.register(for: container)
    DMProfileSuccessPendingInitializer.register(for: container)
    DMAffiliationsInitializer.register(for: container)
    DMCertificationsInitializer.register(for: container)
    DMLicenseSelectionInitializer.register(for: container)
    DMSkillsInitializer.register(for: container)
    DMSelectSkillsInitializer.register(for: container)
    DMStudyInitializer.register(for: container)
    DMSchoolListPopOverInitializer.register(for: container)
    DMExecutiveSummaryInitializer.register(for: container)
    DMWorkExperienceInitializer.register(for: container)
    DMJobTitleSelectionInitializer.register(for: container)
    DMWorkExperienceStartInitializer.register(for: container)
    JobSearchListScreenInitializer.register(for: container)
    JobSearchMapScreenInitializer.register(for: container)
    DaySelectScreenInitializer.register(for: container)
    
    return container
}
