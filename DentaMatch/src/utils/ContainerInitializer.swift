import Foundation
import Swinject
import SwinjectStoryboard

var appContainer: Container {
    return AppDelegate.delegate().container
}

func defaultContainer() -> Container {
    
    Container.loggingFunction = nil
    let container = Container()
    
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
    
    return container
}
