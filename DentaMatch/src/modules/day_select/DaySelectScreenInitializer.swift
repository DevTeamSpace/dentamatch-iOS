import Foundation
import Swinject

class DaySelectScreenInitializer {

    class func initialize(selectedDates: [Date], moduleOutput: DaySelectScreenModuleOutput) -> (DaySelectScreenModuleInput?, UIViewController?) {
        guard let viewInput = appContainer.resolve(DaySelectScreenViewInput.self) else { return (nil, nil) }

        let presenter = appContainer.resolve(DaySelectScreenPresenterProtocol.self, arguments: selectedDates, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return (presenter, viewInput.viewController())
    }

    class func register(for container: Container) {

        container.register(DaySelectScreenPresenterProtocol.self) { r, dates, viewInput, moduleOutput in
            return DaySelectScreenPresenter(dates: dates, viewInput: viewInput, moduleOutput: moduleOutput)
        }

        container.register(DaySelectScreenViewInput.self) { r in
            DaySelectScreenViewController(nibName: "DaySelectScreenView", bundle: nil)
        }
    }
}
